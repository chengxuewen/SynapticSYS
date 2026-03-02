Language: [中文](./cn/05-愿景与技术架构.md) | English

# Vision and Technical Architecture

### 📄 Core Project Document: SynapticSYS Platform Vision and Technical Architecture

**Document Status**: Internal Discussion Draft  
**Organization Date**: October 27, 2023  
**Core Objective**: Define "SynapticSYS"—a full-link, graphical integrated development and runtime platform for highly complex real-time systems.

---

### Part 1: Core Vision and Requirements Overview

**1.1 Project Positioning**  
SynapticSYS aims to become the next-generation development platform for building **highly complex real-time systems** in industrial automation, robotics, digital twins, and other fields. It deeply integrates traditional SCADA, configuration software, modern distributed architecture, and visual development tools.

**1.2 Core Requirements Summary**  
The requirements you proposed go far beyond a single tool; it's a complete ecosystem:

- **Architecture**: A **multi-process, multi-node distributed microservice architecture** similar to ROS 2, but with native support for **C++, C#, Python** mixed programming.
- **Development Experience**: Provide a one-stop graphical IDE, integrating **Blueprint Editor** (logic flow) and **UI Editor** (HMI).
- **Operation and Maintenance**: Possess **full-link observability**, including log playback, HMI recording, remote debugging, and remote desktop.
- **Production Deployment**: Support one-stop **build, packaging, and containerized deployment** from development to production.
- **Ecosystem and Compatibility**: Consider compatibility strategies with existing ecosystems (such as ROS), but not be bound by them.
- **Advanced Features**: Explore mechanisms for **running cross-language modules within the same process** to flexibly balance debugging efficiency and runtime isolation.

**1.3 Key Decisions Made**

- **Naming**: The project's main brand name is **SynapticSYS**. Its build system can be called `synaptic-build`, and the command-line tool is `synaptic`.
- **Open Source License**: Adopt the **Apache License 2.0**, balancing commercial friendliness with clear patent authorization.
- **Project Structure**: Platform code (`synaptic-platform`) and user project code must be **physically separated**. The platform itself uses a **Monorepo** single codebase to manage all components.
- **Code Directory**: The source code root directory uniformly uses **`src`**.
- **Collaboration Specifications**: Adopt the `Conventional Commits` specification, documented in `CONTRIBUTING.md`.
- **Organization and Repository**: Create a unified organization (such as `synapticsys`) on Gitee/GitHub, with the main platform repository named `platform`.

---

### Part 2: Core Technology Stack and Architecture Decisions

**2.1 Build System and Package Manager**

- **Conclusion**: Do not directly adopt Catkin, Colcon, or Ament. Need to **develop independently** `synaptic-build`.
- **Core Philosophy**:

  - **Learn from Colcon's "coordinator" architecture**: As a meta-build tool, responsible for package discovery, dependency resolution, and task scheduling, rather than delving into build details.
  - **Learn from scikit-build's "integration mode"**: As a good practice reference for C++/CMake backends.
  - **Take `synaptic.yaml` as the only source of truth**: Define project and package metadata, dependencies.
- **Technology Stack**: The core coordinator is developed in **Python**, calling various language native tools (`CMake`, `dotnet`, `pip`) through plugins.

**2.2 Communication and Runtime**

- **Communication Abstraction Layer**: Need to design **`Synaptic Link`** (communication manager), which supports DDS, MQTT, WebSocket and other protocols in a plug-in form, ensuring that the architecture is not locked to a specific middleware.
- **Runtime Service Management**: Need to implement a service manager responsible for the lifecycle (start, stop, monitor, dependency) of microservice nodes.
- **Dependency Management**: Clearly define `build_deps` (build-time dependencies) and `exec_deps` (runtime dependencies) in `synaptic.yaml`, which are resolved by the build tool and ensure transitivity.

**2.3 Cross-language In-process Microservice Mechanism**

- **Conclusion**: This is the **core advanced feature** that defines the platform's advancement, but it is recommended to implement it in stages.
- **Reference Projects**: Can deeply learn from frameworks based on OSGi concepts such as **CppMicroServices**, **CTK**, **Apache Celix**, learning their mechanisms for **dynamic library (Bundle) loading, service registration and discovery, and lifecycle management**.
- **Implementation Path**:

  1. Design a language-agnostic **unified service abstraction layer**.
  2. Implement **runtime adaptation layers** for C++, C#, and Python respectively to handle bridging with the unified layer, memory management, and garbage collection coordination.
  3. Implement **configuration-driven** to allow services to switch between "in-process plugin" and "independent process" modes.

**2.4 Containerization and Ecosystem Compatibility**

- **Conclusion**: Using **containerization** is the best path to achieve ROS compatibility and solve environment isolation problems, with low risk and clear benefits.
- **Solution**: Encapsulate different versions of ROS runtime environments into Docker containers, and the container manager of SynapticSYS will uniformly schedule them. Through configuring container networks, realize communication between SynapticSYS nodes and ROS nodes in containers. This avoids direct compatibility with ROS build systems (Ament) and keeps the architecture pure.

**2.5 IDE Integration Strategy**

- **Conclusion**: Prioritize providing a first-class development experience for **VS Code** as a differentiated advantage.
- **Solution**: The `synaptic ide-integrate` command automatically generates:

  - **`.vscode/tasks.json`**: Generate build and test tasks for all packages.
  - **`.vscode/launch.json`**: Generate debugging configurations for executable services.
  - **`compile_commands.json`**: Provide perfect intelligent perception for C++ code.
- **Note**: It is not recommended to generate a twisted "universal CMake file" that contains all language projects, as this will lead to confusion in build logic and degradation of IDE functionality.

---

### Part 3: Key Challenges and Outstanding Issues

**3.1 Core Technical Challenges to be Solved**

1. **Cross-language Data Exchange and Memory Management**: Safely and efficiently passing complex data between C++, C#, and Python within the same process is the biggest challenge, requiring the design of precise ownership and lifecycle protocols.
2. **Multi-language Unified Debugging Experience**: How to enable developers to seamlessly debug a service call chain spanning three languages in the IDE requires deep customization of the toolchain.
3. **Performance and Resource Trade-offs**: The specific trade-off indicators between in-process mode and independent process mode in terms of latency, resource isolation, and reliability need to be determined through prototype testing.

**3.2 Recent Action Recommendations**

1. **Start `synaptic.yaml` specification design**: This is the cornerstone of all tools, and its syntax needs to be clarified immediately.
2. **Implement the minimum prototype of `synaptic-build`**: Support only package discovery, dependency resolution, and sequential build of pure C++ workspaces to verify the core process.
3. **Verify the containerized ROS communication prototype**: Use Docker Compose to quickly verify the feasibility of communication between SynapticSYS nodes and ROS container nodes, opening up the path of ecosystem compatibility.
4. **Deeply investigate frameworks such as CppMicroServices**: Provide specific technical input for its in-process dynamic architecture design.

‍