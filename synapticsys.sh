#!/bin/sh -e

rootDir=$(X= cd -- "$(dirname -- "$0")" && pwd -P)

argBuildMode="core"
argVCSMode="init"
argTargets=""
argSkipFinished=false
argWorkDir="$rootDir/src"
argBuildDir="$rootDir/build"
argInstallDir="$rootDir/install"
while [ $# -gt 0 ]; do
    case "$1" in
        --build-mode)
            if [ "$2" = "all" ] || [ "$2" = "core" ] || [ "$2" = "base" ] || [ "$2" = "none" ]; then
                argBuildMode="$2"
                shift 2
            else
                echo "Error: Invalid build mode. Use 'all', 'core', 'base', or 'none'."
                exit 1
            fi
            ;;
        --vcs-mode)
            if [ "$2" = "force" ] || [ "$2" = "init" ] || [ "$2" = "ignore" ]; then
                argVCSMode="$2"
                shift 2
            else
                echo "Error: Invalid VCS mode. Use 'force', 'init', or 'ignore'."
                exit 1
            fi
            ;;
        --work-dir)
            if [ -n "$2" ]; then
                argWorkDir="$2"
                shift 2
            else
                echo "Error: Invalid work dir."
                exit 1
            fi
            ;;
        --build-dir)
            if [ -n "$2" ]; then
                argBuildDir="$2"
                shift 2
            else
                echo "Error: Invalid build dir."
                exit 1
            fi
            ;;
        --install-dir)
            if [ -n "$2" ]; then
                argInstallDir="$2"
                shift 2
            else
                echo "Error: Invalid install dir."
                exit 1
            fi
            ;;
        --targets)
            shift
            while [ $# -gt 0 ] && ! echo "$1" | grep -q "^--"; do
                if [ -z "$argTargets" ]; then
                    argTargets="$1"
                else
                    argTargets="$argTargets $1"
                fi
                shift
            done
            if [ -z "$argTargets" ]; then
                echo "Error: --targets requires at least one value"
                exit 1
            fi
            ;;
        --skip-finished)
            if [ "$2" = "true" ] || [ "$2" = "false" ]; then
                argSkipFinished="$2"
                shift 2
            else
                echo "Error: Invalid skip finished option. Use 'true', or 'false'."
                exit 1
            fi
            ;;
        *)
            echo "Error: Unknown parameter $1"
            exit 1
            ;;
    esac
done


if command -v pixi >/dev/null 2>&1; then
    echo "pixi is installed"
else
    echo "pixi is not installed, start install pixi..."
    wget -qO- https://pixi.sh/install.sh | sh
    if [ -f "$HOME/.zshrc" ]; then
        source "$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc"
    fi
fi

# install platform dependency packages
cd "$rootDir" || { echo "Unable to enter directory: $rootDir"; exit 1; }
echo "pixi lock..."
pixi lock
echo "pixi install..."
pixi install
echo "pixi install pixi-pack..."
pixi global install pixi-pack
PIXI_ENV=$(pixi run bash -c "echo \$CONDA_PREFIX")

mkdir -p "$rootDir/src/deps"
if [ "$argVCSMode" = "force" ]; then
    echo "vcs update deps..."
    pixi run vcs import --input $rootDir/src/core.repos $rootDir/src/deps --force
    pixi run vcs import --input $rootDir/src/extensions.repos $rootDir/src/deps --force
elif [ "$argVCSMode" = "init" ]; then
    echo "vcs check deps..."
    pixi run vcs import --input $rootDir/src/core.repos $rootDir/src/deps
    pixi run vcs import --input $rootDir/src/extensions.repos $rootDir/src/deps
elif [ "$argVCSMode" = "ignore" ]; then
    echo "vcs ignore..."
fi

if [ "$argVCSMode" != "ignore" ]; then
    # Apply patches from src/patches directory
    echo "Applying patches from src/patches directory..."
    # Recursively find all patch files in src/patches
    find "$rootDir/src/patches" -name "*.patch" | while read -r patch_file; do
        # Get relative path from src/patches to the patch file
        relative_path=$(echo "$patch_file" | sed "s|^$rootDir/src/patches/||")
        # Extract repository path by removing the patch file name
        repo_path=$(dirname "$relative_path")
        # Full path to the repository in src/deps
        full_repo_path="$rootDir/src/deps/$repo_path"
        # Check if the repository directory exists
        if [ -d "$full_repo_path" ]; then
            cd "$full_repo_path"
            if git apply --check "$patch_file" 2>/dev/null; then
                echo "Applying patch $patch_file to $repo_path"
                # Change to the repository directory and apply the patch
                git apply "$patch_file" 2>/dev/null
                if [ $? -eq 0 ]; then
                    echo "✓ Successfully applied patch to $repo_path"
                else
                    echo "✗ Failed to apply patch to $repo_path"
                fi
            else
                echo "✓ Already applied patch $patch_file to $repo_path"
            fi
        else
            echo "⚠ Repository directory $full_repo_path does not exist, skipping patch"
        fi
    done
fi

echo "Enter root directory $rootDir..."
cd "$rootDir" || { echo "Unable to enter directory: $rootDir"; exit 1; }
echo "bash $argInstallDir/setup.bash"
addonCMDS=""
if [ -n "$argTargets" ]; then
    echo "Set packages up to $argTargets..."
    addonCMDS="$addonCMDS --packages-up-to $argTargets"
fi
if [ "$argSkipFinished" = "true" ]; then
    echo "Set packages skip build finished..."
    addonCMDS="$addonCMDS --packages-skip-build-finished"
fi
#bash "$argInstallDir/setup.bash"
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export PKG_CONFIG_PATH=$PIXI_ENV/lib/pkgconfig:$PKG_CONFIG_PATH
export CPLUS_INCLUDE_PATH=$PIXI_ENV/include:$CPLUS_INCLUDE_PATH
export C_INCLUDE_PATH=$PIXI_ENV/include:$C_INCLUDE_PATH
export CMAKE_INCLUDE_PATH=$PIXI_ENV/include
export LD_LIBRARY_PATH=$PIXI_ENV/lib
export LIBRARY_PATH=$PIXI_ENV/lib
export CMAKE_PREFIX_PATH=$PIXI_ENV
if [ "$argBuildMode" = "all" ]; then
    echo "Building full packages..."
    pixi run colcon build \
      --merge-install \
      --base-path "$rootDir/src" "$argWorkDir" \
      --build-base "$argBuildDir" \
      --install-base "$argInstallDir" \
      --metas "$rootDir/packages.meta" \
      --packages-ignore lttngpy \
      $addonCMDS \
      --cmake-args -DBUILD_TESTING=OFF
elif [ "$argBuildMode" = "core" ]; then
    echo "Building core packages..."
    pixi run colcon build \
      --merge-install \
      --base-path "$rootDir/src/deps/core" "$rootDir/src/core" \
      --build-base "$argBuildDir" \
      --install-base "$argInstallDir" \
      --metas "$rootDir/packages.meta" \
      --packages-ignore lttngpy \
      $addonCMDS \
      --cmake-args -DBUILD_TESTING=OFF
fi