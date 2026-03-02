# ROS2 Integration

This document details the ROS2 (Robot Operating System 2) integration approach, usage methods, and configuration options in SynapticSYS.

## 1. Overview

SynapticSYS is built **on top of ROS2**, leveraging its powerful capabilities for robotics and distributed systems. This integration provides:

- **ROS2 Core Components**: Full integration with ROS2 core libraries and tools
- **Standard Development Workflow**: ROS2-compliant package creation and management
- **Seamless Communication**: Leveraging ROS2's DDS-based communication system
- **Rich Ecosystem**: Access to the extensive ROS2 package ecosystem
- **Simplified Development**: Higher-level abstractions while maintaining ROS2 compatibility

## 2. Architecture Positioning

### 2.1 Based on ROS2, Not Alternative

SynapticSYS is **not** designed to replace ROS2. Instead, it:

- Builds upon ROS2's proven architecture and tools
- Extends ROS2 with additional capabilities and abstractions
- Maintains full compatibility with ROS2 packages and tools
- Simplifies common development tasks while preserving flexibility

### 2.2 Key Benefits of ROS2 Foundation

- **Mature Ecosystem**: Access to thousands of existing ROS2 packages
- **Standardized Interfaces**: Consistent APIs for nodes, topics, services, and actions
- **Distributed Architecture**: Built-in support for distributed systems
- **Real-time Capabilities**: Support for real-time applications
- **Cross-platform**: Works on Linux, macOS, and Windows

## 3. Installation and Dependencies

### 3.1 System Requirements

- CMake 3.15+
- C++17 compatible compiler
- Python 3.8+
- Git
- Pixi (environment management tool)

### 3.2 ROS2 Dependencies

SynapticSYS integrates with the following ROS2 core components:

- ament_cmake (build system)
- rclcpp (C++ client library)
- rclpy (Python client library)
- rosidl (interface definition language)
- std_msgs, sensor_msgs, etc. (common message types)

### 3.3 Setup Process

SynapticSYS provides a streamlined setup process using the `bootstrap.sh` script:

1. **Clone SynapticSYS**:
   ```bash
   git clone https://github.com/your-org/SynapticSYS.git
   cd SynapticSYS
   ```

2. **Run Bootstrap Script**:
   ```bash
   chmod +x bootstrap.sh
   ./bootstrap.sh
   ```

3. **Activate Environment**:
   ```bash
   source build-tools/venv/bin/activate
   ```

The bootstrap script automatically:
- Installs Pixi if not already installed
- Sets up the development environment
- Installs required dependencies
- Clones ROS2 repositories using vcs
- Applies patches from src/patches directory
- Builds the project using Colcon

## 4. Development Workflow

### 4.1 Creating ROS2 Packages

SynapticSYS provides a streamlined workflow for creating ROS2 packages:

1. **Create Package**:
   ```bash
   synaptic ros2 create-pkg my_package --dependencies rclcpp std_msgs
   ```

2. **Package Structure**:
   ```
   my_package/
   ├── CMakeLists.txt       # CMake configuration
   ├── package.xml          # Package metadata
   ├── include/my_package/  # Header files
   ├── src/                 # Source files
   ├── msg/                 # Message definitions
   ├── srv/                 # Service definitions
   └── action/              # Action definitions
   ```

### 4.2 Building Packages

- **Build Single Package**:
  ```bash
  cd my_package
  colcon build --packages-select my_package
  ```

- **Build All Packages**:
  ```bash
  colcon build
  ```

### 4.3 Running Nodes

- **Source Workspace**:
  ```bash
  source install/setup.bash
  ```

- **Run Node**:
  ```bash
  ros2 run my_package my_node
  ```

## 5. SynapticSYS Extensions

### 5.1 Python API

SynapticSYS provides a Python API that wraps and extends ROS2 functionality:

```python
from synaptic.ros2 import get_ros2_adapter

# Get ROS2 adapter
ros2_adapter = get_ros2_adapter()

# Run node
ros2_adapter.run_node('my_package', 'my_node')

# List nodes
nodes = ros2_adapter.list_nodes()
print(f"Running nodes: {nodes}")

# List topics
topics = ros2_adapter.list_topics()
print(f"Available topics: {topics}")
```

### 5.2 Configuration Management

SynapticSYS simplifies ROS2 configuration with a unified config system:

```python
from synaptic.ros2.ros2_utils import ROS2Utils

# Create ROS2 utilities instance
utils = ROS2Utils()

# Check ROS2 availability
is_available = utils.is_ros2_available()
print(f"ROS2 available: {is_available}")

# Get ROS2 version
version = utils.get_ros2_version()
print(f"ROS2 version: {version}")
```

### 5.3 Service Discovery

Enhanced service discovery and management:

```python
from synaptic.ros2.ros2_cli import ROS2CLI

# Create ROS2 CLI instance
cli = ROS2CLI()

# List services
services = cli.list_services()
print(f"Available services: {services}")

# Call service
response = cli.call_service('/add_two_ints', 'example_interfaces/srv/AddTwoInts', '{"a": 1, "b": 2}')
print(f"Service response: {response}")
```

## 6. Best Practices

### 6.1 ROS2 Package Development

1. **Follow ROS2 Conventions**:
   - Use standard package structure
   - Follow naming conventions
   - Use ament_cmake build system

2. **Message Design**:
   - Keep messages small and focused
   - Use appropriate data types
   - Avoid deep nesting

3. **Node Design**:
   - Single responsibility per node
   - Use proper QoS settings
   - Avoid long-running operations in callbacks

### 6.2 Performance Optimization

1. **Build Optimization**:
   ```bash
   colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release
   ```

2. **Runtime Optimization**:
   - Use appropriate QoS profiles
   - Optimize message frequency
   - Consider using intra-process communication for co-located nodes

3. **Resource Management**:
   - Properly release resources
   - Use timers instead of busy-waiting
   - Monitor memory usage

### 6.3 Testing

1. **Unit Tests**:
   - Test individual components
   - Use gtest for C++ code
   - Use pytest for Python code

2. **Integration Tests**:
   - Test component interactions
   - Use launch files for complex scenarios

3. **ROS2-Specific Tests**:
   - Test topic publishing/subscribing
   - Test service calls
   - Test action servers/clients

## 7. Advanced Configuration

### 7.1 Environment Variables

Key ROS2 environment variables that can be configured:

- **ROS_DOMAIN_ID**: Isolates ROS2 systems (default: 0)
- **RMW_IMPLEMENTATION**: Specifies the DDS implementation (e.g., `rmw_cyclonedds_cpp`, `rmw_fastrtps_cpp`)
- **ROS2_HOME**: Overrides the default ROS2 configuration directory

### 7.2 DDS Configuration

SynapticSYS supports custom DDS configurations for advanced use cases:

- **CycloneDDS**: `cyclonedds.xml` configuration file
- **FastDDS**: `fastdds.xml` configuration file

### 7.3 Build Configuration

CMake options for ROS2 integration:

- **BUILD_WITH_ROS2**: Enable/disable ROS2 integration (default: ON)
- **ROS2_INSTALL_DIR**: Specify custom ROS2 installation directory
- **USE_SYSTEM_ROS2**: Use system-installed ROS2 instead of built-in (default: ON)

## 8. Troubleshooting

### 8.1 Common Issues

1. **ROS2 Not Found**:
   - **Cause**: ROS2 environment not sourced
   - **Solution**: Source the ROS2 setup file

2. **Package Not Found**:
   - **Cause**: Package not built or not in ROS_PACKAGE_PATH
   - **Solution**: Build the package and source the workspace

3. **Communication Issues**:
   - **Cause**: Network issues or DDS configuration problems
   - **Solution**: Check network connectivity and DDS settings

4. **Build Failures**:
   - **Cause**: Missing dependencies or compilation errors
   - **Solution**: Install dependencies and fix compilation errors

### 8.2 Debugging Tips

1. **Enable Verbose Output**:
   ```bash
   ros2 run my_package my_node --ros-args --log-level debug
   ```

2. **Check ROS2 Environment**:
   ```bash
   env | grep ROS
   ```

3. **List Available Resources**:
   ```bash
   ros2 node list
   ros2 topic list
   ros2 service list
   ```

4. **Monitor System**:
   ```bash
   ros2 topic echo /rosout
   ```

## 9. Migration Guide

### 9.1 From ROS1 to ROS2

SynapticSYS supports a smooth migration path from ROS1 to ROS2:

1. **Assess Existing Code**:
   - Identify ROS1-specific APIs and patterns
   - Plan for ROS2 compatibility

2. **Update Package Structure**:
   - Convert `package.xml` to format 3
   - Update CMakeLists.txt for ament_cmake

3. **Update Code**:
   - Replace ROS1 APIs with ROS2 equivalents
   - Update message/service definitions
   - Adapt to ROS2's callback groups and executors

4. **Test Thoroughly**:
   - Test each component individually
   - Test system integration

### 9.2 From Custom Systems to ROS2

For systems migrating to ROS2 through SynapticSYS:

1. **Identify Core Functionality**:
   - Map existing functionality to ROS2 concepts
   - Identify gaps that need to be filled

2. **Design ROS2 Interface**:
   - Define messages, services, and actions
   - Design node structure

3. **Implement Adapter Layer**:
   - Create adapters between existing code and ROS2
   - Gradually migrate functionality

4. **Leverage SynapticSYS Abstractions**:
   - Use higher-level APIs where appropriate
   - Maintain compatibility with ROS2 tools

## 10. Conclusion

SynapticSYS's **ROS2-based architecture** provides a powerful foundation for developing complex robotic and control systems. By building on top of ROS2 rather than reinventing it, SynapticSYS:

- **Reduces Development Effort**: Leverages existing ROS2 components and tools
- **Increases Compatibility**: Works seamlessly with the ROS2 ecosystem
- **Provides Flexibility**: Maintains access to low-level ROS2 functionality when needed
- **Accelerates Development**: Offers higher-level abstractions for common tasks
- **Ensures Long-term Viability**: Built on a widely adopted, actively maintained platform

This approach significantly reduces development complexity while providing all the benefits of a modern robotics framework.

---

🔗 [Back to Home](./index.md)