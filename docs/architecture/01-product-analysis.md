Language: [中文](./cn/01-产品分析.md) | English

# Product Analysis

Integrates Blueprint Editor, UI Editor, DDS communication, microservice management, multi-process, peripherals (steering wheel, IO modules, USB), HMI display, web maps, logging, chart playback, HMI recording, remote desktop, and remote development/debugging.

## Integration Dimensions

| Dimension | Specific Capability | Industry Benchmark and Deep Analysis |
| ---------- | ----------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **1. Development Paradigm Integration** | **Blueprint Editor** (behavior logic) + **UI Editor** (interaction interface). | Similar to the combination of **Unreal Engine** Blueprints and **Qt Designer**, but targeted at **industrial control and robotic behavior flows** rather than games or generic UIs. The editor must handle real-time signal flows and state machines. |
| **2. Communication and Architecture Integration** | **DDS communication** (real-time data bus) + **microservice management** + **multi-process**. | This is the core of **autonomous driving/robotics ROS 2 architecture**. DDS ensures deterministic communication; microservices and multi-process provide modularity and fault tolerance. The platform must seamlessly manage deployment, discovery, and lifecycle of this complex distributed system. |
| **3. Multimodal I/O and Interaction Integration** | **Peripherals** (steering wheel, IO modules, USB) + **HMI display** + **Web maps**. | Requires a **device abstraction layer** that unifies physical operations, traditional HMI, and GIS information into a single data context and event loop. Similar to **CARLA simulator** or **agricultural/ UAV control stations**. |
| **4. Full Lifecycle Observability Integration** | **Logging/chart playback** + **HMI recording** + **remote desktop/debugging**. | Critical for tackling system complexity. Not just recording data, but **spatio-temporal synchronized reproduction** of “what the system saw (HMI recording), what it did (logs), and why (data replay)”, with remote intervention support. This is a combination of a **“digital black box”** and a **“time-machine debugger”**. |

## Essence of the System

An IDE and OS middleware for building and running a “software-hardware digital twin”.

A full-stack, software-hardware integrated development and runtime platform for high-complexity real-time systems.

## Unique Challenges

1. **Balancing real-time and usability**: Visual editing must not compromise DDS determinism.
2. **Encapsulation vs. exposure of complexity**: Hide distributed deployment complexity from developers while exposing sufficient debugging information.
3. **Vertical domain integration**: Deep understanding of robotics, control, GIS, etc., abstracted into reusable modules.

## Competitive Advantages

The combination of a **ROS2-based distributed node architecture** and a **full-chain developer toolset** (blueprints, remote debugging) is the unique advantage. Naming should highlight this, rather than only "cloud-native".

---

🔗 [Back to Home](./index.md) | [Next: Naming Analysis](./02-naming-analysis.md)