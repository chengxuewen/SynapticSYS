#!/bin/sh -e

rootDir=$(X= cd -- "$(dirname -- "$0")" && pwd -P)

argBuildMode="full"
argVCSMode="init"
argWorkDir="$rootDir"
argBuildDir="$rootDir/build"
argInstallDir="$rootDir/install"
while [ $# -gt 0 ]; do
    case "$1" in
        --mode)
            if [ "$2" = "full" ] || [ "$2" = "skip" ] || [ "$2" = "base" ] || [ "$2" = "none" ]; then
                argBuildMode="$2"
                shift 2
            else
                echo "Error: Invalid build mode. Use 'full', 'skip', 'base', or 'none'."
                exit 1
            fi
            ;;
        --vcs)
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
cd "$argWorkDir" || { echo "Unable to enter directory: $argWorkDir"; exit 1; }
echo "pixi lock..."
pixi lock
echo "pixi install..."
pixi install
echo "pixi install pixi-pack..."
pixi global install pixi-pack

if [ "$argVCSMode" = "force" ]; then
    echo "vcs update deps..."
    pixi run vcs import --input src/repos src/deps --force
elif [ "$argVCSMode" = "init" ]; then
    echo "vcs check deps..."
    mkdir -p "src/deps"
    pixi run vcs import --input src/repos src/deps
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

cd "$argWorkDir" || { echo "Unable to enter directory: $argWorkDir"; exit 1; }
echo "Enter work directory $argWorkDir"
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
if [ "$argBuildMode" = "full" ]; then
    echo "Building full packages..."
    pixi run colcon build \
      --symlink-install \
      --base-path "$rootDir/src" "$argWorkDir/src" \
      --build-base "$argBuildDir" \
      --install-base "$argInstallDir" \
      --cmake-args -DBUILD_TESTING=OFF
elif [ "$argBuildMode" = "skip" ]; then
    echo "Building base packages..."
    pixi run colcon build \
      --symlink-install \
      --base-path "$rootDir/src" "$argWorkDir/src" \
      --build-base "$argBuildDir" \
      --install-base "$argInstallDir" \
      --packages-skip-build-finished \
      --cmake-args -DBUILD_TESTING=OFF
elif [ "$argBuildMode" = "base" ]; then
    echo "Building base packages..."
    pixi run colcon build \
      --symlink-install \
      --base-path "$rootDir/src" "$argWorkDir/src" \
      --build-base "$argBuildDir" \
      --install-base "$argInstallDir" \
      --packages-up-to synapticsys_base \
      --cmake-args -DBUILD_TESTING=OFF
fi