Language: [中文](./cn/12-开发步骤.md) | English

# Development Steps

Building a complex system like “SynapticSYS” cannot be done in one shot. Adopt a **progressive, MVP-driven** strategy, delivering verifiable value at each step and laying a solid foundation for the core architecture.

Below is a **four-phase progressive roadmap**, each phase focusing on a clear goal with runnable, demoable outcomes.

## 🗺️ Four-Phase Roadmap

| Phase | Goal | Key Outputs | Core Tech | Duration |
|-----|------|--------|--------|--------|
| **Phase 1: Foundation** | Prove DDS-based distributed node communication | Cross-language demo | C#, C++, Python, Fast DDS | 8–10 weeks |
| **Phase 2: Enablement** | Complete dev/build/deploy loop | CLI tool, package management | C#, MSBuild, Docker | 12–16 weeks |
| **Phase 3: Elevation** | Visual editors and developer UX | Blueprint editor, UI editor | Blazor, Vue.js, WebSocket | 20–24 weeks |
| **Phase 4: Polish** | Full observability and remote capabilities | Logging, remote debugging, dashboards | ELK, Grafana, gRPC | 16–20 weeks |

---

## 🔧 Phase Details and Deliverables

### **Phase 1: Foundation (Core Communication + Minimal Runtime)**

#### Core Goal
Prove feasibility of “multi-language nodes communicating over a unified bus”.

#### Key Technology Choices
- **Framework core**: C#
- **Multi-language**: C++, Python
- **Middleware**: DDS (Fast DDS or CycloneDDS)
- **Build tools**: MSBuild, CMake, Python setuptools

#### Main Tasks

1. **Design Service Interface Description (.syn format)**
   - Define message and service structures
   - Support basic types (int, float, string, array, struct)
   - Versioning mechanism

2. **Code Generator (Python)**
   - Parse `.syn` files
   - Generate C++, C#, Python data structures
   - Serialization/deserialization support

3. **Core Communication Layer (C#)**
   - Wrap DDS library
   - Provide simple **pub/sub** and **service call** APIs
   - Error handling and logging

4. **Minimal Runtime (C#)**
   - Load config (YAML/JSON)
   - Start node processes (local/remote)
   - Process lifecycle management

5. **Example Nodes**
   - C++ publisher/subscriber
   - C# publisher/subscriber
   - Python publisher/subscriber
   - Demonstrate cross-language communication

#### Deliverables
- ✅ Runnable demo: nodes in three languages can exchange messages
- ✅ Code generation tool
- ✅ Base SDK and examples
- ✅ Getting-started docs

---

### **Phase 2: Enablement (Service Management + Build/Deploy)**

#### Core Goal
Establish a complete loop: develop → build → deploy.

#### Key Technology Choices
- **CLI tool**: Python or Go (Python recommended for extensibility)
- **Package management**: npm-like concept, self-hosted or existing
- **Containerization**: Docker, Docker Compose
- **Config management**: YAML, Helm (optional)

#### Main Tasks

1. **Design `synaptic.yaml` Package Metadata**
   - Name, version, language, entry points
   - Dependency declarations
   - Runtime requirements

2. **Implement `synaptic` CLI**
   - `synaptic init <project-name>`: initialize project
   - `synaptic build`: build service
   - `synaptic pack`: package service
   - `synaptic run`: run locally
   - `synaptic deploy`: deploy to runtime

3. **Package Management & Registry**
   - Local or cloud registry
   - Versioning and dependency resolution
   - Publish, download, install flows

4. **Docker Integration**
   - Auto-generate Dockerfile
   - Multi-language images
   - Basic orchestration (Compose)

5. **Config and Service Discovery**
   - Environment variables and config files
   - Basic service registration/discovery (DDS-based)

#### Deliverables
- ✅ Full-featured `synaptic` CLI tool
- ✅ Package system and registry
- ✅ Docker support
- ✅ Project templates and scaffolding
- ✅ Complete developer guides and best practices

---

### **Phase 3: Elevation (Editors & Visual Development)**

#### Core Goal
Enable no-code/low-code development via visual editors.

#### Key Technology Choices
- **Frontend**: Blazor Server or WebAssembly
- **Visualization libs**: in-house or OSS (X6, D3.js)
- **Realtime comms**: WebSocket, SignalR
- **UI components**: Material Design, Bootstrap

#### Main Tasks

1. **Blueprint Editor (Behavior Logic)**
   - Drag-and-drop node editing
   - Node library (sources, processors, sinks)
   - Connection management
   - Debugging and step execution

2. **UI Editor (Interface Design)**
   - Component library (buttons, inputs, charts)
   - Drag-and-drop canvas
   - Properties panel
   - Live preview

3. **Project Management UI**
   - File tree
   - VCS integration
   - Publish and deploy management

4. **Realtime Collaboration (Foundations)**
   - Multi-user live editing (optional; refined in Phase 4)
   - Change synchronization

#### Deliverables
- ✅ Full-featured blueprint editor
- ✅ Full-featured UI editor
- ✅ SynapticSYS Studio (initial)
- ✅ Editor user guide

---

### **Phase 4: Polish (Observability & Remote)**

#### Core Goal
Enable developers to observe, debug, and remotely control the entire system.

#### Key Technology Choices
- **Logging**: ELK Stack or Loki
- **Metrics & Tracing**: Prometheus, Jaeger
- **Dashboards**: Grafana, in-house
- **Remote debugging**: gRPC, WebSocket
- **Recording & replay**: FFmpeg, in-house

#### Main Tasks

1. **Logging & Tracing**
   - Unified log collection and storage
   - Log querying and filtering
   - Distributed tracing

2. **Metrics & Monitoring**
   - System metrics (CPU, memory, network)
   - App metrics (latency, throughput)
   - Live dashboards

3. **Remote Debug & Control**
   - Remote connect/login
   - Remote code execution (safe sandbox)
   - Live log viewing
   - Inspect/modify variables

4. **HMI Recording & Replay**
   - Record HMI screen and events
   - Timeline replay
   - Time-align with logs and data

5. **Advanced Observability**
   - Performance analysis (flame graphs)
   - Memory leak detection
   - Deadlock detection

#### Deliverables
- ✅ Complete logging and monitoring
- ✅ Remote debugging tools
- ✅ HMI recording and replay
- ✅ SynapticSYS 1.0
- ✅ Complete docs and best practices

---

## 📊 Milestones and Decision Points

| Time | Decision | Notes |
|-------|------|------|
| End of Phase 1 | **Go/No-Go** | If DDS validation fails, reassess architecture |
| End of Phase 2 | **Open-source Feasibility** | Consider open-sourcing parts, invite community |
| End of Phase 3 | **Beta Users** | Gather early feedback |
| End of Phase 4 | **1.0 Release** | Full product release, commercialization |

---

## 🎯 Success Criteria

### Phase 1
- [ ] Cross-language node communication demo
- [ ] Code generator usable
- [ ] SDK docs complete

### Phase 2
- [ ] CLI tool usable end-to-end
- [ ] Full dev flow via `synaptic`
- [ ] Docker deployment succeeds

### Phase 3
- [ ] Blueprint editor edits simple dataflows
- [ ] UI editor designs basic UIs
- [ ] Exported code runs in runtime

### Phase 4
- [ ] Log replay viewable
- [ ] Performance metrics visible
- [ ] Remote debugging in basic scenarios
- [ ] All docs complete

---

---

🔗 [Back to Home](./index.md) | [Previous: Communication Management](./04-communication-management.md) | [Next: Web HMI Tech Stack](./06-web-hmi-tech-stack.md)