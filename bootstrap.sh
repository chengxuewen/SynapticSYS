#!/bin/sh -e

ssysRootDir=$(X= cd -- "$(dirname -- "$0")" && pwd -P)

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
echo "pixi lock..."
pixi lock
echo "pixi install..."
pixi install

echo "vcs check deps..."
pixi run vcs import --input src/repos src/deps

# Apply patches from src/patches directory
echo "Applying patches from src/patches directory..."
# Recursively find all patch files in src/patches
find "$ssysRootDir/src/patches" -name "*.patch" | while read -r patch_file; do
    # Get relative path from src/patches to the patch file
    relative_path=$(echo "$patch_file" | sed "s|^$ssysRootDir/src/patches/||")
    # Extract repository path by removing the patch file name
    repo_path=$(dirname "$relative_path")
    # Full path to the repository in src/deps
    full_repo_path="$ssysRootDir/src/deps/$repo_path"
    # Check if the repository directory exists
    if [ -d "$full_repo_path" ]; then
        if git apply --check "$patch_file" 2>/dev/null; then
            echo "Applying patch $patch_file to $repo_path"
            # Change to the repository directory and apply the patch
            (cd "$full_repo_path" && git apply "$patch_file")
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

export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
pixi run colcon build --symlink-install --base-path src --cmake-args -DBUILD_TESTING=OFF 
