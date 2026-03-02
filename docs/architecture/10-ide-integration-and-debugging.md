Language: [中文](./cn/10-IDE集成与调试方案.md) | English

# IDE Integration and Debugging Solution

### 📋 Technical Document: SynapticSYS IDE Integration and Debugging Solution

**Document Version**: V1.1  
**Core Topic**: Achieving unified IDE project support and debugging integration through a CMake wrapper layer  
**Last Organized Context**: [Core Project Document: SynapticSYS Platform Vision and Technical Architecture](./05-vision-and-architecture.md)

---

### Part 1: Solution Origin and Core Objectives

**1.1 Problem Background**  
Under SynapticSYS's distributed, multi-language microservice architecture, developers face two major experience breakpoints:

1. **Project Browsing Fragmentation**: Packages in different languages (C++/C#/Python) are scattered in the workspace, and the IDE cannot provide a unified project view for code navigation and global search.
2. **Debugging Process Complexity**: Unit testing, service startup, and debugging cannot be performed directly in the IDE, relying on external command lines, which breaks the fluency of modern integrated development environments.

**1.2 Core Objectives**  
Design a non-intrusive solution to achieve the following goals:

- **Unified View**: Load the entire SynapticSYS workspace as a single project in mainstream IDEs (such as CLion, Visual Studio, VS Code) to browse source code in all languages without distinction.
- **Seamless Build**: When triggering a build in the IDE, it can automatically call the correct `synaptic` command to execute the real, dependency-aware build process.
- **Integrated Debugging**: Deeply integrate unit testing, service running, and debugging into the IDE's "Run/Debug" menu for one-click debugging.

**1.3 Design Principles**

- **Decoupling**: The auxiliary layer generated for the IDE must be decoupled from the real build system (`synaptic-build`) and never interfere with or rewrite build logic.
- **Declarative**: All information required for IDE support should come from `synaptic.yaml` as the only source of truth.
- **Automation**: The generation of the entire IDE configuration should be fully automated, without requiring developers to manually write or maintain it.

---

### Part 2: Core Solution: CMake Wrapper Layer

**2.1 Overall Architecture**  
We introduce a dedicated tool called `synaptic cmake-wrapper`. This tool reads the `synaptic.yaml` file in the workspace and generates an IDE-only `CMakeLists.txt.ide` file in **each package's source directory**. At the same time, it generates a top-level `CMakeLists.txt.ide` in the **workspace root directory** to aggregate all packages.

**2.2 Detailed Content of Wrapper CMake Files**  
The generated `CMakeLists.txt.ide` core is to define a series of **custom targets** that bridge IDE operations to the `synaptic` CLI.

- **Basic Build and Install Targets**:  
  cmake

  ```
  # ${package_path}/CMakeLists.txt.ide
  cmake_minimum_required(VERSION 3.15)
  project(${PACKAGE_NAME}_IDE_Helper NONE)

  # Core: Build target
  add_custom_target(build_${PACKAGE_NAME}
      COMMAND synaptic build --package ${PACKAGE_NAME}
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMENT "Build package using synaptic: ${PACKAGE_NAME}"
  )
  # Core: Install target
  add_custom_target(install_${PACKAGE_NAME}
      COMMAND synaptic install --package ${PACKAGE_NAME}
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      DEPENDS build_${PACKAGE_NAME}
  )
  ```
- **Unit Test Integration**: Through declaring an `IMPORTED` executable target, let the IDE recognize the debugging entry.  
  cmake

  ```
  # Declare test executable file (path约定 by synaptic-build)
  add_executable(${PACKAGE_NAME}_tests IMPORTED GLOBAL)
  set_target_properties(${PACKAGE_NAME}_tests PROPERTIES
      IMPORTED_LOCATION ${SYNAPTIC_DEVEL_DIR}/bin/${PACKAGE_NAME}_tests
  )
  # Define a custom command to run tests
  add_custom_target(test_${PACKAGE_NAME}
      COMMAND ${SYNAPTIC_DEVEL_DIR}/bin/${PACKAGE_NAME}_tests
      DEPENDS build_${PACKAGE_NAME}
  )
  ```
- **Application Debugging Integration**:  
  cmake

  ```
  # Declare main application (for debugger attachment)
  add_executable(${PACKAGE_NAME}_app IMPORTED GLOBAL)
  set_target_properties(${PACKAGE_NAME}_app PROPERTIES
      IMPORTED_LOCATION ${SYNAPTIC_INSTALL_DIR}/bin/${PACKAGE_NAME}_app
      VS_DEBUGGER_WORKING_DIRECTORY "${SYNAPTIC_INSTALL_DIR}"
  )
  # Define run target
  add_custom_target(run_${PACKAGE_NAME}
      COMMAND synaptic run --package ${PACKAGE_NAME}
      DEPENDS install_${PACKAGE_NAME}
  )
  ```

**2.3 Top-level Project File**  
The root directory's `CMakeLists.txt.ide` simply aggregates all packages:

cmake

```
cmake_minimum_required(VERSION 3.15)
project(MySynapticWorkspace NONE)
add_subdirectory(src/pkg1)
add_subdirectory(src/pkg2)
# ... automatically add all packages
```

---

### Part 3: Complete Workflow in IDE

| Development Stage | Developer Operation | System Response and Underlying Logic |
| ----------| -----------------------------------------------------| -----------------------------------------------------------------------------------|
|**1. Project Import**|Open `/CMakeLists.txt.ide` in IDE|IDE executes CMake configuration, loads all wrapper layers, and generates a tree structure containing **all language source files** in the project view.| 
|**2. Code Writing**|Browse and edit C++/C#/Python code.|IDE provides code highlighting, completion, and navigation based on file extensions and project context provided by CMake.| 
|**3. Build Project**|Click "Build" button in IDE or right-click specific package's `build_xxx` target.|IDE triggers the `COMMAND` of the corresponding custom target, executes `synaptic build --package xxx`, and outputs real build logs in the terminal.| 
|**4. Run Tests**|Select `test_xxx` target from "Run" menu.|IDE runs the test executable file and can view reports in its integrated "Test Results" panel.| 
|**5. Debug Application**|Select `xxx_app` or `xxx_tests` target from "Debug" menu and set breakpoints.|IDE uses native debuggers (GDB/CDB/LLDB) to start the executable file, enabling source-level single-step debugging and variable viewing.| 
|**6. Start Service**|Select `run_xxx` target from "Run" menu.|IDE starts the service in an integrated terminal or background process, and developers can view real-time logs.| 

---

### Part 4: Key Advantages and Notes

**4.1 Core Advantages**

- **Unified Experience**: Converges the development experience of distributed, multi-language projects into a familiar IDE environment.
- **Clear Responsibilities**: The wrapper layer only acts as a "forwarder", and the real build logic is still managed by `synaptic-build`, with a clean architecture.
- **Highly Automated**: Automatically generated by parsing `synaptic.yaml`, no need to manually maintain CMake files.
- **Debugging Friendly**: Directly utilize the IDE's powerful native debugger without configuring complex remote debugging.

**4.2 Implementation Notes and Challenges**

1. **Source File Indexing**: CMake can naturally index C++ files. For C# `.cs` and Python `.py` files, basic syntax highlighting and project tree inclusion can be achieved through the `SOURCES` property of `add_custom_target` or relying on IDE plugins, but complete intelligent perception still requires corresponding language plugins.
2. **Path Synchronization**: The paths in `IMPORTED_LOCATION` (such as `${SYNAPTIC_DEVEL_DIR}`) must be **strictly consistent** with the actual output directory of `synaptic-build`. This requires clear conventions or shared configuration between the two tools.
3. **Performance Considerations**: Including hundreds of subdirectories may slow down CMake's initial configuration speed. Consider supporting on-demand generation of wrapper layers.
4. **Advanced Debugging**: For `runtime: in_process` plugin services, debugging is more complex. It may be necessary to generate special debugging targets to start the host process with debugging parameters and let the IDE attach to the process.

---

### Part 5: Next Action Plan

1. **Define Output Conventions**: In the `synaptic.yaml` specification, clearly define the `outputs` field to declare the executable file and library file paths produced by the package. This is the basis for the wrapper layer to generate `IMPORTED_LOCATION`.
2. **Implement `synaptic cmake-wrapper` Prototype**:

   - Phase 1: Implement the basic framework, which can generate wrapper layers containing `build_` and `install_` targets.
   - Phase 2: Extend to support identifying tests/applications from `synaptic.yaml` and generate corresponding debugging and running targets.
3. **Conduct End-to-End Verification**:

   - Select a sample workspace containing C++ libraries, C++ tests, and C# applications.
   - Run the tool to generate wrapper layers.
   - Open it in CLion or Visual Studio to fully verify the entire process from **code navigation -> build -> test debugging -> application running**.
