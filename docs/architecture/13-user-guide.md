Language: [中文](./cn/13-用户指南.md) | English

# SynapticSYS User Guide

## 1. Introduction

SynapticSYS is a powerful multi-language build system that supports CMake, Python, Meson, and other build systems, providing automatic dependency handling, topological sorting, parallel building, incremental building, and other features. This guide will help you quickly get started with the SynapticSYS build system.

## 2. Installation

### 2.1 System Requirements

- Python 3.8 or higher
- Supported operating systems:
  - Windows 10/11
  - macOS 10.15 or higher
  - Linux (Ubuntu 18.04+, Debian 10+, Fedora 30+)

### 2.2 Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-organization/SynapticSYS.git
   cd SynapticSYS
   ```

2. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Install SynapticSYS**
   ```bash
   pip install -e .
   ```

4. **Verify installation**
   ```bash
   synaptic --version
   ```

## 3. Basic Concepts

### 3.1 Workspace

SynapticSYS uses a workspace structure similar to Catkin/Colcon, typically containing the following directories:

- `src/`: Stores source code packages
- `build/`: Build output directory (automatically generated)
- `install/`: Installation directory (automatically generated)
- `log/`: Log directory (automatically generated)

### 3.2 Package

A package is the basic building unit in SynapticSYS, and each package typically contains:

- Build configuration files (such as CMakeLists.txt, setup.py, meson.build, etc.)
- Source files
- Optional `package.xml` file for declaring dependencies

### 3.3 Dependencies

SynapticSYS supports multiple types of dependencies:

- `dependencies`: Runtime dependencies
- `build_dependencies`: Build-time dependencies
- `build_export_dependencies`: Build export dependencies
- `exec_dependencies`: Execution dependencies
- `test_dependencies`: Test dependencies

## 4. Command Line Tools

### 4.1 Basic Commands

```bash
# Show help information
synaptic --help

# Show version information
synaptic --version
```

### 4.2 Build Commands

```bash
# Build all packages
synaptic build

# Build specified packages
synaptic build --packages-select pkg1 pkg2

# Skip specified packages
synaptic build --packages-skip pkg1 pkg2

# Build up to specified package (including dependencies)
synaptic build --packages-up-to pkg1

# Build dependencies of specified package
synaptic build --packages-above pkg1
```

### 4.3 Build Options

```bash
# Specify build target (default: release)
synaptic build --target debug

# Specify number of parallel jobs
synaptic build --jobs 4

# Enable symlink install
synaptic build --symlink-install

# Disable incremental build
synaptic build --no-incremental

# Enable verbose output
synaptic build --verbose
```

### 4.4 Other Commands

```bash
# Run tests
synaptic test

# Generate test coverage report
synaptic coverage

# Clean build directory
synaptic clean

# Generate dependency graph
synaptic graph

# Run static code analysis
synaptic static-analysis

# Package project
synaptic package
```

## 5. Configuration Files

### 5.1 Global Configuration

SynapticSYS uses `synaptic.yaml` as the configuration file, located in the workspace root directory:

```yaml
project:
  name: my_project
  version: 1.0.0

build:
  target: release
  jobs: 4
  symlink_install: false
  merge_install: true
  incremental: true
  verify: false

ci:
  enabled: false
  report_formats: [json]
  report_output: stdout

static_analysis:
  enabled: false
  tools: []

package_recognition:
  rules: []
```

### 5.2 Package Configuration

Each package can contain a `package.xml` file for declaring dependencies:

```xml
<?xml version="1.0"?>
<package format="3">
  <name>my_package</name>
  <version>1.0.0</version>
  <description>My package description</description>
  
  <depend>dep1</depend>
  <build_depend>build_dep1</build_depend>
  <build_export_depend>build_export_dep1</build_export_depend>
  <exec_depend>exec_dep1</exec_depend>
  <test_depend>test_dep1</test_depend>
</package>
```

## 6. Usage Examples

### 6.1 Basic Build Process

1. **Create a workspace**
   ```bash
   mkdir -p my_workspace/src
   cd my_workspace
   ```

2. **Create an example package**
   ```bash
   # Create example package in src directory
   cd src
   git clone https://github.com/example/example_package.git
   cd ..
   ```

3. **Build packages**
   ```bash
   synaptic build
   ```

4. **Run tests**
   ```bash
   synaptic test
   ```

5. **Generate dependency graph**
   ```bash
   synaptic graph
   ```

### 6.2 Advanced Usage Scenarios

#### 6.2.1 Multi-target Build

```bash
# Build debug and release targets
synaptic build --target debug,release
```

#### 6.2.2 Custom Build Directory

```bash
# Use custom build and install directories
synaptic build --build-base my_build --install-base my_install
```

#### 6.2.3 Continue Building Failed Packages

```bash
# Continue building other packages even if some packages fail
synaptic build --continue-on-error
```

## 7. Advanced Features

### 7.1 Plugin System

SynapticSYS supports plugin extensions, allowing the addition of new build system support or custom functionality. Please refer to [Plugin Development Guide](11-plugin-development.md) for the plugin development guide.

### 7.2 Environment Scripts

After the build is complete, SynapticSYS generates environment scripts for setting up the runtime environment:

```bash
# Bash environment
source install/setup.sh

# Fish environment
source install/setup.fish

# Windows environment
install\setup.bat
```

### 7.3 Build History

SynapticSYS saves build history records, which can be viewed with the following commands:

```bash
# View build history
synaptic history

# View specific build details
synaptic history --build-id build_1234567890
```

## 8. Common Issues

### 8.1 Build Failures

If the build fails, try the following solutions:

1. Check the error message, which usually shows the specific reason for the failure
2. Clean the build directory: `synaptic clean`
3. Check if dependencies are correctly declared
4. Try using the `--verbose` option to get more detailed output

### 8.2 Dependency Resolution Issues

If dependency resolution fails:

1. Ensure all dependency packages exist in the `src` directory
2. Check if the dependency declarations in the `package.xml` file are correct
3. Ensure that the dependency package names match the actual package names

### 8.3 Environment Variable Issues

If you encounter environment variable issues during runtime:

1. Ensure you have correctly sourced the environment script
2. Check if environment variables such as `PYTHONPATH` and `CMAKE_PREFIX_PATH` are correctly set
3. Try regenerating the environment script: `synaptic build --symlink-install`

## 9. Contributing

If you find issues or have improvement suggestions, please:

1. Check existing [GitHub Issues](https://github.com/your-organization/SynapticSYS/issues)
2. Create a new Issue or Pull Request
3. Follow the project's contribution guidelines

## 10. License

SynapticSYS is licensed under the [Apache License 2.0](../../LICENSE).

## 11. Contact Information

- Project homepage: https://github.com/your-organization/SynapticSYS
- Documentation: https://your-organization.github.io/SynapticSYS/
- Issue feedback: https://github.com/your-organization/SynapticSYS/issues

---

© 2026 SynapticSYS Team