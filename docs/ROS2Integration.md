# ROS2 Integration Document

This document details the ROS2 integration approach, usage methods, and configuration options in SynapticSYS, based on Pixi environment management and Colcon build system.

## 1. Overview

SynapticSYS is built on top of ROS2 (Robot Operating System 2), providing the following features:

- ROS2 core components integration and management
- ROS2 package creation and management
- Support for ROS2 nodes, topics, services, and actions
- ROS2 message and service generation
- Seamless integration between ROS2 and SynapticSYS
- Pixi-based environment management
- Colcon-based build system

## 2. Installation Dependencies

### 2.1 System Requirements

- CMake 3.15+
- C++17 compatible compiler
- Python 3.8+
- Git
- Pixi (environment management tool)

### 2.2 ROS2 Dependencies

SynapticSYS manages ROS2 core components through vcs tool, including:

- ament_cmake
- ament_index
- rcl
- rclcpp
- rosidl
- rcutils
- rmw
- rmw_implementation

### 2.3 Using bootstrap.sh Script to Configure Environment

SynapticSYS provides a `bootstrap.sh` script to automatically configure the development environment, including installing Pixi, setting up dependencies, and building the project:

```bash
# Run bootstrap script
chmod +x bootstrap.sh
./bootstrap.sh

# Activate environment
source build-tools/venv/bin/activate
```

## 3. Build Configuration

### 3.1 Colcon-based Build System

SynapticSYS uses Colcon as the build system for ROS2 packages, providing a more flexible and standard ROS2 build experience.

### 3.2 Build Process

1. **Automatic build using bootstrap script**:
   ```bash
   # Running bootstrap script will automatically execute the build
   ./bootstrap.sh
   ```

2. **Manual build**:
   ```bash
   # Use Pixi to run Colcon build
   pixi run colcon build --symlink-install --base-path src
   
   # Activate ROS2 environment
   source install/setup.bash
   ```

3. **Build specific packages**:
   ```bash
   # Build specific package
   pixi run colcon build --packages-select my_package
   
   # Build dependent packages
   pixi run colcon build --packages-up-to my_package
   ```

4. **Clean build**:
   ```bash
   # Clean build artifacts
   pixi run colcon build --clean-first
   ```

## 4. CMake Macros and Functions

### 4.1 Basic Macros

#### `find_ros2_package(package_name)`

Find the specified ROS2 package.

**Parameters**:
- `package_name`: Name of the ROS2 package to find

**Example**:
```cmake
find_ros2_package(rclcpp)
```

#### `target_link_ros2_cpp(target)`

Link ROS2 C++ libraries to the specified target.

**Parameters**:
- `target`: Target name

**Example**:
```cmake
target_link_ros2_cpp(my_node)
```

#### `target_link_ros2_python(target)`

Link ROS2 Python libraries to the specified target.

**Parameters**:
- `target`: Target name

**Example**:
```cmake
target_link_ros2_python(my_python_module)
```

### 4.2 Messages and Services

#### `generate_ros2_messages(target_name [msg_files...])`

Generate ROS2 messages.

**Parameters**:
- `target_name`: Target name
- `msg_files`: List of message files

**Example**:
```cmake
generate_ros2_messages(my_package msg/MyMessage.msg msg/AnotherMessage.msg)
```

#### `generate_ros2_services(target_name [srv_files...])`

Generate ROS2 services.

**Parameters**:
- `target_name`: Target name
- `srv_files`: List of service files

**Example**:
```cmake
generate_ros2_services(my_package srv/MyService.srv)
```

#### `generate_ros2_actions(target_name [action_files...])`

Generate ROS2 actions.

**Parameters**:
- `target_name`: Target name
- `action_files`: List of action files

**Example**:
```cmake
generate_ros2_actions(my_package action/MyAction.action)
```

### 4.3 Target Management

#### `add_ros2_node(node_name [src_files...])`

Create a ROS2 node.

**Parameters**:
- `node_name`: Node name
- `src_files`: List of source files

**Example**:
```cmake
add_ros2_node(my_node src/node.cpp)
```

#### `add_ros2_library(library_name [src_files...])`

Create a ROS2 library.

**Parameters**:
- `library_name`: Library name
- `src_files`: List of source files

**Example**:
```cmake
add_ros2_library(my_library src/library.cpp)
```

### 4.4 Export and Package Management

#### `ros2_export_targets(target)`

Export ROS2 targets.

**Parameters**:
- `target`: Target name

**Example**:
```cmake
ros2_export_targets(my_library)
```

#### `ros2_export_dependencies([dependencies...])`

Export ROS2 dependencies.

**Parameters**:
- `dependencies`: List of dependency packages

**Example**:
```cmake
ros2_export_dependencies(rclcpp std_msgs)
```

#### `ros2_export_include_directories([dirs...])`

Export ROS2 include directories.

**Parameters**:
- `dirs`: List of include directories

**Example**:
```cmake
ros2_export_include_directories(include)
```

#### `ros2_export_libraries([libraries...])`

Export ROS2 libraries.

**Parameters**:
- `libraries`: List of libraries

**Example**:
```cmake
ros2_export_libraries(my_library)
```

#### `ros2_package_finalize()`

Finalize ROS2 package.

**Example**:
```cmake
ros2_package_finalize()
```

### 4.5 Environment and Tools

#### `set_ros2_environment()`

Set ROS2 environment variables.

**Example**:
```cmake
set_ros2_environment()
```

#### `check_ros2_version()`

Check ROS2 version.

**Return value**:
- `ROS2_VERSION`: ROS2 version

**Example**:
```cmake
check_ros2_version()
message(STATUS "ROS2 version: ${ROS2_VERSION}")
```

#### `validate_ros2_installation()`

Validate ROS2 installation.

**Return value**:
- `ROS2_INSTALLATION_VALID`: Whether the installation is valid

**Example**:
```cmake
validate_ros2_installation()
if(ROS2_INSTALLATION_VALID)
    message(STATUS "ROS2 installation is valid")
else()
    message(WARNING "ROS2 installation is invalid")
endif()
```

## 5. ROS2 Package Structure

### 5.1 Standard ROS2 Package Structure

ROS2 packages in SynapticSYS follow the standard ROS2 package structure:

```
package_name/
├── CMakeLists.txt       # CMake configuration file
├── package.xml          # Package information file
├── include/             # Header files directory
│   └── package_name/    # Package-specific header files
├── src/                 # Source files directory
├── msg/                 # Message definition directory
├── srv/                 # Service definition directory
└── action/              # Action definition directory
```

### 5.2 Creating ROS2 Package

1. **Create directory structure**:
   ```bash
   mkdir -p packages/my_package/{include/my_package,src,msg,srv,action}
   ```

2. **Create CMakeLists.txt**:
   ```cmake
   cmake_minimum_required(VERSION 3.15)
   project(my_package)

   # Include ROS2 dependencies
   find_package(ament_cmake REQUIRED)
   find_package(rclcpp REQUIRED)
   find_package(std_msgs REQUIRED)

   # Add executable
   add_executable(my_node src/node.cpp)
   ament_target_dependencies(my_node rclcpp std_msgs)

   # Install executable
   install(TARGETS my_node
     DESTINATION lib/${PROJECT_NAME})

   # Finalize package
   ament_package()
   ```

3. **Create package.xml**:
   ```xml
   <?xml version="1.0"?>
   <?xml-model href="http://download.ros.org/schema/package_format3.xsd" schematypens="http://www.w3.org/2001/XMLSchema"?>
   <package format="3">
     <name>my_package</name>
     <version>0.1.0</version>
     <description>My ROS2 package</description>
     <maintainer email="user@example.com">User</maintainer>
     <license>Apache-2.0</license>

     <depend>rclcpp</depend>
     <depend>std_msgs</depend>

     <test_depend>ament_lint_auto</test_depend>
     <test_depend>ament_lint_common</test_depend>

     <export>
       <build_type>ament_cmake</build_type>
     </export>
   </package>
   ```

## 6. Python API

### 6.1 Backend Abstraction Layer

SynapticSYS provides a backend abstraction layer that supports ROS2 as a backend:

```python
from synaptic.backend import get_backend

# Get ROS2 backend
backend = get_backend('ros2')

# Use backend API
backend.init()
backend.shutdown()
```

### 6.2 ROS2 Adapter

SynapticSYS provides a ROS2 adapter for interacting with the ROS2 system:

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

# List services
services = ros2_adapter.list_services()
print(f"Available services: {services}")

# Get node info
node_info = ros2_adapter.get_node_info('/my_node')
print(f"Node info: {node_info}")

# Get topic info
topic_info = ros2_adapter.get_topic_info('/chatter')
print(f"Topic info: {topic_info}")

# Get service info
service_info = ros2_adapter.get_service_info('/add_two_ints')
print(f"Service info: {service_info}")
```

### 6.3 ROS2 Command Line Interface

SynapticSYS provides a wrapper for the ROS2 command line interface:

```python
from synaptic.ros2.ros2_cli import ROS2CLI

# Create ROS2 CLI instance
cli = ROS2CLI()

# Call service
response = cli.call_service('/add_two_ints', 'example_interfaces/srv/AddTwoInts', '{"a": 1, "b": 2}')
print(f"Service response: {response}")

# List parameters
params = cli.list_parameters('/my_node')
print(f"Node parameters: {params}")

# Get parameter value
value = cli.get_parameter('/my_node', 'param_name')
print(f"Parameter value: {value}")

# Set parameter value
success = cli.set_parameter('/my_node', 'param_name', 'new_value')
print(f"Set parameter success: {success}")
```

### 6.4 ROS2 Tools

SynapticSYS provides ROS2 utility classes for obtaining ROS2-related information:

```python
from synaptic.ros2.ros2_utils import ROS2Utils

# Create ROS2 utils instance
utils = ROS2Utils()

# Check if ROS2 is available
is_available = utils.is_ros2_available()
print(f"ROS2 available: {is_available}")

# Get ROS2 version
version = utils.get_ros2_version()
print(f"ROS2 version: {version}")

# Get ROS2 package list
packages = utils.get_ros2_packages()
print(f"ROS2 packages: {packages}")

# Get package path
package_path = utils.get_package_path('rclcpp')
print(f"rclcpp package path: {package_path}")

# Get package dependencies
dependencies = utils.get_package_dependencies('rclcpp')
print(f"rclcpp dependencies: {dependencies}")

# Get ROS2 environment variables
env = utils.get_ros2_environment()
print(f"ROS2 environment: {env}")

# Get ROS2 domain ID
domain_id = utils.get_ros2_domain_id()
print(f"ROS2 domain ID: {domain_id}")

# Set ROS2 domain ID
utils.set_ros2_domain_id(1)

# Get RMW implementation
rmw_impl = utils.get_rmw_implementation()
print(f"RMW implementation: {rmw_impl}")

# Set RMW implementation
utils.set_rmw_implementation('rmw_cyclonedds_cpp')
```

## 7. Examples

### 7.1 Creating a Simple ROS2 Node

**CMakeLists.txt**:

```cmake
cmake_minimum_required(VERSION 3.15)
project(my_ros2_node)

# Include ROS2 dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)

# Add executable
add_executable(my_node src/node.cpp)
ament_target_dependencies(my_node rclcpp std_msgs)

# Install executable
install(TARGETS my_node
  DESTINATION lib/${PROJECT_NAME})

# Finalize package
ament_package()
```

**src/node.cpp**:

```cpp
#include "rclcpp/rclcpp.hpp"
#include "std_msgs/msg/string.hpp"

class MyNode : public rclcpp::Node
{
public:
    MyNode() : Node("my_node")
    {
        publisher_ = this->create_publisher<std_msgs::msg::String>("/chatter", 10);
        timer_ = this->create_wall_timer(
            std::chrono::seconds(1),
            std::bind(&MyNode::timer_callback, this)
        );
        RCLCPP_INFO(this->get_logger(), "Node initialized");
    }

private:
    void timer_callback()
    {
        auto message = std_msgs::msg::String();
        message.data = "Hello, ROS2!";
        publisher_->publish(message);
        RCLCPP_INFO(this->get_logger(), "Published: %s", message.data.c_str());
    }

    rclcpp::Publisher<std_msgs::msg::String>::SharedPtr publisher_;
    rclcpp::TimerBase::SharedPtr timer_;
};

int main(int argc, char * argv[])
{
    rclcpp::init(argc, argv);
    rclcpp::spin(std::make_shared<MyNode>());
    rclcpp::shutdown();
    return 0;
}
```

### 7.2 Creating a ROS2 Service

**srv/AddTwoInts.srv**:

```
int64 a
int64 b
---
int64 sum
```

**CMakeLists.txt**:

```cmake
cmake_minimum_required(VERSION 3.15)
project(my_ros2_service)

# Include ROS2 dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(rosidl_default_generators REQUIRED)

# Generate services
rosidl_generate_interfaces(${PROJECT_NAME}
  srv/AddTwoInts.srv
)

# Add executable
add_executable(service_node src/service_node.cpp)
ament_target_dependencies(service_node rclcpp)
rosidl_target_interfaces(service_node ${PROJECT_NAME} "rosidl_typesupport_cpp")

# Install executable
install(TARGETS service_node
  DESTINATION lib/${PROJECT_NAME})

# Finalize package
ament_package()
```

**src/service_node.cpp**:

```cpp
#include "rclcpp/rclcpp.hpp"
#include "my_ros2_service/srv/add_two_ints.hpp"

class ServiceNode : public rclcpp::Node
{
public:
    ServiceNode() : Node("service_node")
    {
        service_ = this->create_service<my_ros2_service::srv::AddTwoInts>(
            "add_two_ints",
            std::bind(&ServiceNode::add_two_ints_callback, this, std::placeholders::_1, std::placeholders::_2)
        );
        RCLCPP_INFO(this->get_logger(), "Service initialized");
    }

private:
    void add_two_ints_callback(
        const std::shared_ptr<my_ros2_service::srv::AddTwoInts::Request> request,
        const std::shared_ptr<my_ros2_service::srv::AddTwoInts::Response> response
    )
    {
        response->sum = request->a + request->b;
        RCLCPP_INFO(this->get_logger(), "Received request: a=%ld, b=%ld", request->a, request->b);
        RCLCPP_INFO(this->get_logger(), "Sending response: sum=%ld", response->sum);
    }

    rclcpp::Service<my_ros2_service::srv::AddTwoInts>::SharedPtr service_;
};

int main(int argc, char * argv[])
{
    rclcpp::init(argc, argv);
    rclcpp::spin(std::make_shared<ServiceNode>());
    rclcpp::shutdown();
    return 0;
}
```

### 7.3 Running Examples

```bash
# Run publisher node
pixi run ros2 run my_ros2_node my_node

# Run service node
pixi run ros2 run my_ros2_service service_node

# Run service client
pixi run ros2 service call /add_two_ints my_ros2_service/srv/AddTwoInts "{a: 1, b: 2}"
```

## 8. Troubleshooting

### 8.1 Common Issues

1. **Pixi not installed**
   - **Cause**: Pixi is not installed in the system
   - **Solution**: Run `curl -fsSL https://pixi.sh/install.sh | bash` to install Pixi

2. **bootstrap.sh script not executable**
   - **Cause**: The script does not have execute permission
   - **Solution**: Run `chmod +x bootstrap.sh` to grant execute permission

3. **Cannot find ROS2 package: xxx**
   - **Cause**: The specified ROS2 package does not exist or is not installed
   - **Solution**: Ensure the package is declared in `src/repos` and run `./bootstrap.sh` to rebuild

4. **Failed to generate ROS2 messages**
   - **Cause**: Message file format error or missing dependencies
   - **Solution**: Check message file format and ensure all dependencies are correctly declared in `package.xml`

5. **Colcon build failed**
   - **Cause**: Error occurred during build process
   - **Solution**: Check build logs, fix errors, and rerun `pixi run colcon build`

6. **RMW implementation not found**
   - **Cause**: RMW implementation not set
   - **Solution**: Set environment variable `export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp` or other available RMW implementation

### 8.2 Debugging Tips

1. **Enable detailed logs**:
   ```bash
   cmake .. -DCMAKE_MESSAGE_LOG_LEVEL=DEBUG
   ```

2. **Check ROS2 environment**:
   ```bash
   source /opt/ros/humble/setup.bash  # Or corresponding ROS2 version
   env | grep ROS
   ```

3. **Check ROS2 package path**:
   ```bash
   ros2 pkg list | grep my_package
   ```

4. **Check ROS2 nodes**:
   ```bash
   ros2 node list
   ```

5. **Check ROS2 topics**:
   ```bash
   ros2 topic list
   ```

6. **Check ROS2 services**:
   ```bash
   ros2 service list
   ```

## 9. Advanced Configuration

### 9.1 RMW Implementation Configuration

ROS2 uses RMW (ROS Middleware) to interact with the underlying DDS system. You can set the RMW implementation through environment variables:

```bash
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp  # Use CycloneDDS
export RMW_IMPLEMENTATION=rmw_fastrtps_cpp     # Use FastDDS
```

### 9.2 Domain ID Configuration

ROS2 uses domain ID to isolate different ROS2 systems. You can set the domain ID through environment variables:

```bash
export ROS_DOMAIN_ID=0  # Default domain ID
export ROS_DOMAIN_ID=1  # Different domain ID
```

### 9.3 Performance Optimization

#### 9.3.1 Build Performance Optimization

1. **Compilation optimization**:
   ```bash
   cmake .. -DCMAKE_BUILD_TYPE=Release
   ```

2. **Parallel build**:
   ```bash
   cmake --build . --parallel $(nproc)
   ```

3. **Build cache**:
   SynapticSYS supports ccache to speed up builds:
   ```bash
   # Ensure ccache is installed
   sudo apt install ccache  # Ubuntu
   brew install ccache      # macOS
   
   # Automatically use ccache during build
   cmake .. -DBUILD_WITH_ROS2=ON
   cmake --build . --target ros2_build
   ```

4. **Build generator optimization**:
   - Unix Makefiles (default)
   - Ninja (faster incremental builds)
   ```bash
   cmake .. -G Ninja -DBUILD_WITH_ROS2=ON
   ```

5. **Parallel job count optimization**:
   SynapticSYS automatically detects the number of CPU cores and limits the maximum parallel jobs to 8 to avoid system overload.

#### 9.3.2 Runtime Performance Optimization

1. **Memory allocation optimization**:
   - Use custom memory allocators
   - Adjust ROS2 message queue size

2. **Network optimization**:
   - Configure DDS transport settings
   - Adjust QoS (Quality of Service) settings

3. **Computation optimization**:
   - Use `-O3` and `-march=native` compilation options
   - Enable link-time optimization (LTO)

### 9.4 Error Handling System

SynapticSYS provides a comprehensive ROS2 error handling system, including error code definitions and error handling functions.

#### 9.4.1 Error Codes

| Error Code | Description | Solution |
|-----------|-------------|----------|
| 0 | No error | Operation successful |
| 1 | ROS2 not built | Run `make ros2_build` to build ROS2 |
| 2 | ROS2 package not found | Ensure the package is correctly installed or add dependency |
| 3 | ROS2 library not found | Rebuild ROS2 core components |
| 4 | ROS2 environment error | Check environment variable settings |
| 5 | ROS2 build error | Check build logs and fix errors |
| 6 | ROS2 runtime error | Check runtime logs and fix errors |
| 7 | ROS2 configuration error | Check configuration files and fix errors |

#### 9.4.2 Error Handling Functions

1. **Get error code**:
   ```cmake
   get_ros2_last_error_code()
   message(STATUS "Last error code: ${ROS2_ERROR_CODE}")
   ```

2. **Get error message**:
   ```cmake
   get_ros2_last_error_message()
   message(STATUS "Last error message: ${ROS2_ERROR_MESSAGE}")
   ```

3. **Reset error state**:
   ```cmake
   reset_ros2_error_state()
   ```

4. **Check error**:
   ```cmake
   check_ros2_error()
   if(ROS2_ERROR_DETECTED)
       message(WARNING "ROS2 error detected")
   endif()
   ```

5. **Handle error**:
   ```cmake
   handle_ros2_error(${ROS2_ERROR_NOT_BUILT} "ROS2 not built")
   ```

### 9.5 GitHub Actions Workflow

SynapticSYS provides GitHub Actions workflow configuration for automated testing and build processes.

#### 9.5.1 Workflow Configuration

The workflow file is located at `.github/workflows/ros2-integration.yml` and includes the following tasks:

1. **build-and-test**: Build and test the project on Ubuntu, supporting multiple Python versions
2. **lint-and-format**: Check Python code style and format
3. **build-multi-platform**: Build the project on Ubuntu and macOS to verify cross-platform compatibility

#### 9.5.2 Workflow Trigger Conditions

- **Push**: When code is pushed to `main` or `develop` branches
- **Pull Request**: When a pull request is created or updated
- **Manual Trigger**: Manually triggered through the GitHub Actions interface

#### 9.5.3 Workflow Environment

- **Ubuntu**: ubuntu-latest
- **macOS**: macos-latest
- **Python**: 3.8, 3.9, 3.10

#### 9.5.4 Workflow Output

- **Test Results**: Show execution status of all tests
- **Code Coverage**: Upload code coverage reports to Codecov
- **Build Logs**: Provide detailed build process logs

### 9.6 Example Usage

SynapticSYS provides several ROS2 examples located in the `examples/ros2/` directory.

#### 9.6.1 Basic Examples

1. **Publisher example**:
   ```bash
   cd examples/ros2
   python publisher_example.py
   ```

2. **Subscriber example**:
   ```bash
   cd examples/ros2
   python subscriber_example.py
   ```

3. **Service server example**:
   ```bash
   cd examples/ros2
   python service_server_example.py
   ```

4. **Client example**:
   ```bash
   cd examples/ros2
   python service_client_example.py
   ```

#### 9.6.2 Advanced Examples

1. **Parameter management example**:
   ```bash
   cd examples/ros2
   python parameter_example.py
   ```

2. **Action server/client example**:
   ```bash
   cd examples/ros2
   python action_example.py
   ```

### 9.7 Best Practices Guide

#### 9.7.1 Code Organization

1. **ROS2 package structure**:
   - Follow standard ROS2 package structure
   - Use clear naming conventions
   - Separate message, service, and action definitions

2. **CMake configuration**:
   - Use macros and functions provided by `ROS2Integration.cmake`
   - Organize build targets in dependency order
   - Use `ros2_package_finalize()` to finalize the package

#### 9.7.2 Performance Best Practices

1. **Message design**:
   - Keep messages small and focused
   - Use appropriate message types
   - Avoid deep message nesting

2. **Node design**:
   - Each node focuses on a single function
   - Use appropriate QoS settings
   - Avoid long-running operations in callbacks

3. **Services and actions**:
   - Use services for short operations
   - Use actions for long operations
   - Provide appropriate error handling

#### 9.7.3 Error Handling

1. **Use error handling system**:
   - Check ROS2 build status
   - Handle missing packages and libraries
   - Provide clear error messages

2. **Logging**:
   - Use appropriate log levels
   - Provide detailed log messages
   - Include context information

#### 9.7.4 Testing

1. **Unit tests**:
   - Test each component's functionality
   - Use mocks and stubs
   - Verify error handling

2. **Integration tests**:
   - Test component interactions
   - Verify ROS2 system integration
   - Test different configurations

3. **End-to-end tests**:
   - Test complete workflows
   - Verify build and run processes
   - Test cross-platform compatibility

#### 9.7.5 Deployment

1. **Build and packaging**:
   - Use `build_and_package.sh` script
   - Include all necessary dependencies
   - Provide clear installation instructions

2. **Environment configuration**:
   - Set correct environment variables
   - Configure appropriate domain ID
   - Choose suitable RMW implementation

3. **Monitoring and maintenance**:
   - Implement health checks
   - Monitor resource usage
   - Provide log collection mechanism

## 10. Summary

SynapticSYS provides comprehensive ROS2 integration, supporting:

- ROS2 core component building and management
- ROS2 package creation and configuration
- ROS2 node, topic, service, and action support
- ROS2 message and service generation
- Python API and backend abstraction layer
- Rich CMake macros and functions

With the guidance of this document, you can easily use ROS2 functionality in SynapticSYS to build complex robotic systems and distributed applications.

## 11. References

- [ROS2 Official Documentation](https://docs.ros.org/en/humble/)
- [ROS2 GitHub Repository](https://github.com/ros2)
- [ament_cmake Documentation](https://github.com/ament/ament_cmake)
- [rclcpp Documentation](https://docs.ros.org/en/humble/API/rclcpp/index.html)
- [CMake Official Documentation](https://cmake.org/documentation/)