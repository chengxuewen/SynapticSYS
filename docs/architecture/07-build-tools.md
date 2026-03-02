Language: [中文](./cn/07-构建工具.md) | English

# Build Tools

## Overview

The build system should support:
- **Multi-language builds** (C#, C++, Python)
- **Dependency management** (NuGet, vcpkg, pip)
- **Multi-target deployment** (local, Docker, Kubernetes)
- **Automation** (build, test, package, release)

## Build Tools Comparison

### Common ROS Build Tools

#### Catkin

**Overview:** Catkin is the primary build system for ROS 1, inspired by CMake but extended for ROS package management.

**Features:**
- ROS package manifest (package.xml)
- Dependency resolution across packages
- Workspace concept (catkin workspace)
- CMake integration

**Limitations:**
- Primarily designed for ROS 1
- Limited multi-language support (focus on C++/Python)
- Less flexible for non-ROS projects

#### Colcon

**Overview:** Colcon is the build system for ROS 2, replacing Catkin, with improved flexibility.

**Features:**
- Supports multiple build systems (CMake, Python setuptools, ament)
- Package discovery across workspaces
- Parallel builds
- Better error handling

**Limitations:**
- Still tightly coupled with ROS ecosystem
- Steep learning curve
- Limited documentation for non-ROS usage

#### ament_cmake

**Overview:** Extension to CMake for ROS 2 packages, used by colcon.

**Features:**
- ROS 2 package management
- Test framework integration
- Linting tools

**Limitations:**
- ROS-specific
- Limited to CMake projects

### Other Multi-Language Build Systems

#### Bazel

**Overview:** Google's build system, designed for large-scale projects.

**Features:**
- Multi-language support (C++, Java, Python, etc.)
- Remote caching and execution
- Hermetic builds
- Scalable for large monorepos

**Limitations:**
- Complex configuration
- Slow initial setup
- Steep learning curve

#### Gradle

**Overview:** Build automation tool with multi-language support.

**Features:**
- Flexible plugin system
- Good dependency management
- Multi-platform support

**Limitations:**
- Java-centric design
- Performance issues with large projects
- Less suitable for C/C++ heavy projects

## Build System Design Philosophy

### Problems with Existing Tools

1. **ROS-centric limitations:** Catkin/Colcon are tightly coupled with ROS ecosystem, making them less suitable for general-purpose projects.
2. **Multi-language challenges:** Most tools excel at specific languages but struggle with heterogeneous environments.
3. **Configuration complexity:** Tools like Bazel have steep learning curves.
4. **Performance issues:** Large monorepos often suffer from slow build times.

### Self-developed Build System Direction

#### Core Requirements

1. **Language-agnostic design:** First-class support for C#, C++, Python, and extensibility for other languages.
2. **ROS compatibility:** Ability to work with ROS 1/2 packages when needed.
3. **Performance optimization:** Incremental builds, parallel execution, and caching.
4. **User-friendly interface:** Simple CLI with intuitive commands.
5. **Extensibility:** Plugin system for custom build logic.

#### Design Architecture

```
+-------------------+
|   Build CLI Tool  |
+-------------------+
          |
+-------------------+
| Core Build Engine |
+-------------------+
          |
+-------------------+
| Language Plugins  |
| - C# (.NET)       |
| - C++ (CMake)     |
| - Python (setuptools) |
| - ROS (Catkin/Colcon) |
+-------------------+
          |
+-------------------+
| Dependency Manager|
+-------------------+
          |
+-------------------+
| Workspace Manager |
+-------------------+
```

#### Key Features to Develop

1. **Unified workspace model:**
   - Support for monorepo and polyrepo workflows
   - Package discovery across multiple directories
   - Consistent build configuration across languages

2. **Smart dependency resolution:**
   - Cross-language dependency tracking
   - Automatic dependency installation
   - Version conflict resolution

3. **Build optimization:**
   - Incremental builds based on file changes
   - Parallel execution across packages
   - Distributed build support
   - Build artifact caching

4. **Testing integration:**
   - Unified test runner interface
   - Test result aggregation
   - Coverage reporting

5. **Deployment automation:**
   - Containerization support (Docker/Kubernetes)
   - Multi-platform builds
   - Release management

## Multi-Cluster Support

### Overview
SynapticSYS supports running multiple instances on the same operating system, forming a **multi-cluster architecture** that enhances system reliability and scalability.

### Key Features

#### Cluster Isolation
- Each cluster operates with **scope-restricted communication**, similar to application-level isolation
- Nodes within the same cluster communicate freely
- Cross-cluster communication requires explicit configuration

#### Module-to-Node Architecture
- Application modules are split into multiple sub-nodes for improved reliability
- Individual node failures do not compromise the entire application
- Better fault tolerance through distributed design

#### Cross-Cluster Communication
- **Node attribute configuration** controls cross-cluster access
- Only nodes with **"global available" attribute** can communicate across clusters
- Fine-grained control over inter-cluster data flow

### Communication Mechanism
- Built on Synaptic Link's DDS-based communication infrastructure
- Maintains consistent messaging interface across clusters
- Supports all communication protocols (Fast DDS, CycloneDDS, MQTT, WebSocket) for cluster communication

## Implementation Roadmap

1. **Phase 1 - Core Infrastructure:**
   - CLI tool development
   - Basic workspace management
   - C# and C++ build support

2. **Phase 2 - Enhanced Features:**
   - Python support
   - Dependency management
   - Testing integration

3. **Phase 3 - Advanced Capabilities:**
   - ROS compatibility
   - Distributed builds
   - Plugin system

4. **Phase 4 - Optimization:**
   - Performance tuning
   - Caching implementation
   - User experience improvements

## Tooling

### C#: MSBuild

```xml
<!-- 例：SynapticSYS.Core.csproj -->
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <OutputType>Library</OutputType>
    <Version>1.0.0</Version>
    <Description>SynapticSYS Core Runtime</Description>
  </PropertyGroup>
  
  <ItemGroup>
    <PackageReference Include="OpenDDSharp.Standard" Version="2.0.0" />
  </ItemGroup>
</Project>
```

Build commands:
```bash
dotnet build -c Release
dotnet pack -c Release -o ./nupkg
```

### C++: CMake

```cmake
# 例：CMakeLists.txt
cmake_minimum_required(VERSION 3.15)
project(SynapticSYS.Native)

# 依赖：Fast DDS
find_package(fastrtps REQUIRED)
find_package(fastcdr REQUIRED)

# 编译目标
add_library(synaptic-native 
  src/communication/dds_wrapper.cpp
  src/communication/node_manager.cpp
)

target_link_libraries(synaptic-native
  fastrtps::fastrtps
  fastcdr::fastcdr
)
```

Build commands:
```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
```

### Python: setuptools

```python
# setup.py
from setuptools import setup, find_packages

setup(
    name='synaptic-sdk-python',
    version='1.0.0',
    packages=find_packages(),
    install_requires=[
        'pydantic>=2.0',
        'aiofiles>=23.0',
    ],
)
```

Build commands:
```bash
python -m build
pip install -e .
```

## Unified Build Entry: `synaptic build`

Design a CLI to hide underlying complexity:

```bash
# 初始化项目
synaptic init my-service --template csharp

# 构建
synaptic build

# 在本地运行
synaptic run

# 打包
synaptic pack

# 发布
synaptic publish
```

Implementation (Python):

```python
# synaptic_cli/builder.py
import subprocess
import os

class Builder:
    def __init__(self, project_root):
        self.project_root = project_root
        self.config = self.load_config()  # 加载 synaptic.yaml
    
    def build(self):
        """根据项目语言调用对应的构建工具"""
        language = self.config.get('language')
        
        if language == 'csharp':
            self._build_csharp()
        elif language == 'cpp':
            self._build_cpp()
        elif language == 'python':
            self._build_python()
    
    def _build_csharp(self):
        subprocess.run(
            ['dotnet', 'build', '-c', 'Release'],
            cwd=self.project_root,
            check=True
        )
    
    def _build_cpp(self):
        build_dir = os.path.join(self.project_root, 'build')
        subprocess.run(['cmake', '-B', build_dir], cwd=self.project_root, check=True)
        subprocess.run(['cmake', '--build', build_dir], cwd=self.project_root, check=True)
```

## Dependency Management

### NuGet (C#)

```bash
# 添加依赖
dotnet add package OpenDDSharp.Standard

# 恢复依赖
dotnet restore
```

### vcpkg (C++)

```bash
# 安装 vcpkg
git clone https://github.com/Microsoft/vcpkg.git
./vcpkg/bootstrap-vcpkg.sh

# 安装库
./vcpkg install fastdds:x64-linux
```

### pip (Python)

```bash
pip install -r requirements.txt
```

## CI/CD

### GitHub Actions Example

```yaml
# .github/workflows/build.yml
name: Build and Test

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup .NET
      uses: actions/setup-dotnet@v3
      with:
        dotnet-version: '8.0'
    
    - name: Restore dependencies
      run: dotnet restore
    
    - name: Build
      run: dotnet build -c Release --no-restore
    
    - name: Run tests
      run: dotnet test -c Release --no-build
    
    - name: Build Docker image
      run: docker build -t synapticsys:latest .
    
    - name: Push to registry
      if: github.ref == 'refs/heads/main'
      run: |
        docker login -u ${{ secrets.DOCKER_USERNAME }} -p ${{ secrets.DOCKER_PASSWORD }}
        docker tag synapticsys:latest myregistry.azurecr.io/synapticsys:${{ github.sha }}
        docker push myregistry.azurecr.io/synapticsys:${{ github.sha }}
```

## Versioning

### Semantic Versioning (SemVer)

```
Major.Minor.Patch[-Prerelease][+Build]
例：1.2.3-alpha+build.123
```

Rules:
- **Major**：重大功能或破坏性改动
- **Minor**：新增功能，向后兼容
- **Patch**：bug 修复
- **Prerelease**：测试版本（alpha、beta、rc）
- **Build**：构建元数据

### Automated Versioning (GitVersion)

```bash
# 安装
dotnet tool install -g GitVersion.Tool

# 生成版本号
gitversion

# 在 CI/CD 中使用
dotnet publish -p:Version=$(gitversion -showvariable semver)
```

## Code Quality

### Static Analysis (Roslyn + StyleCop)

```csharp
// Directory.Build.props
<Project>
  <ItemGroup>
    <PackageReference Include="StyleCop.Analyzers" Version="1.2.0-beta.435">
      <PrivateAssets>all</PrivateAssets>
      <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
    </PackageReference>
  </ItemGroup>
</Project>
```

### Unit Tests

```bash
# 运行所有测试
dotnet test

# 生成覆盖率报告
dotnet test /p:CollectCoverage=true /p:CoverageFormat=opencover
```

### Code Coverage Targets

目标：> 80%

可用工具：
- Coverlet（.NET）
- OpenCover
- SonarQube（持续集成）

## Docker Image Build

### Multi-stage Build

```dockerfile
# 构建阶段
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app
COPY . .
RUN dotnet publish -c Release -o out

# 运行阶段
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/out .
EXPOSE 5000
ENV ASPNETCORE_URLS=http://+:5000
ENTRYPOINT ["dotnet", "SynapticSYS.Runtime.dll"]
```

Build and push:
```bash
docker build -t synapticsys-runtime:1.0.0 .
docker tag synapticsys-runtime:1.0.0 myregistry/synapticsys-runtime:latest
docker push myregistry/synapticsys-runtime:latest
```

## Release Process

### 1. Tagging
```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

### 2. Generate Release Notes
```bash
# 自动生成，基于 commit 日志
git log v0.9.0..v1.0.0 --oneline
```

### 3. Publish to Registries
```bash
# NuGet
dotnet nuget push ./nupkg/SynapticSYS.Core.1.0.0.nupkg -k $NUGET_API_KEY -s https://api.nuget.org/v3/index.json

# Docker Hub
docker push synapticsys-runtime:1.0.0
```

### 4. Update Docs and Changelog
```markdown
# Changelog

## [1.0.0] - 2026-01-20

### Added
- 微内核运行时核心功能
- DDS 通信层
- CLI 工具初版

### Fixed
- 修复 XXX bug

### Changed
- 优化 YYY 性能
```

## Best Practices

1. ✅ **总是构建可重现的构建**（同样的源码→同样的二进制）
2. ✅ **自动化所有测试与部署流程**
3. ✅ **使用容器化打包，保证环境一致**
4. ✅ **记录每个发布版本的完整信息**
5. ✅ **定期清理旧版本和构建产物**

---

---

🔗 [Back to Home](./index.md) | [Web HMI Tech Stack](./06-web-hmi-tech-stack.md) | [Virtual Device](./08-virtual-device.md)