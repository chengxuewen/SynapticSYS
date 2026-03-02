Language: [中文](./cn/index.md) | English
# SynapticSYS Architecture
This folder contains the complete architecture and development planning docs for **SynapticSYS**, organized with a **home → subpages** navigation structure.
## 📑 Document Navigation
### 🎯 Product Positioning
- **[Product Analysis](./01-product-analysis.md)** — integrated capability dimensions, industry benchmarks, challenges and competitive advantages
- **[SynapticSYS Naming](./02-naming-analysis.md)** — naming evolution, value elevation, and business/legal validation
### 🏗️ Core Architecture
- **[Microkernel Services](./03-microkernel-services.md)** — OS-like microkernel design, service orientation, and leap beyond traditional industrial software
- **[Communication Management](./04-communication-management.md)** — DDS middleware, Synaptic Link manager, multi-protocol adapters and roadmap
- **[Vision and Architecture](./05-vision-and-architecture.md)** — core vision, technical architecture decisions and key challenges
### 📋 Development Planning
- **[Development Steps](./12-development-steps.md)** — four-phase MVP roadmap with goals, tasks, and deliverables
### 💻 Technical Implementation
- **[Web HMI Tech Stack](./06-web-hmi-tech-stack.md)** — web-based HMI technology research and implementation
- **[Build Tools](./07-build-tools.md)** — build system design, CI/CD flows, dependency management
- **[Virtual Device](./08-virtual-device.md)** — hardware abstraction and device integration
- **[Builtin Packages](./09-builtin-packages.md)** — builtin packages architecture design and implementation
- **[IDE Integration and Debugging](./10-ide-integration-and-debugging.md)** — IDE integration and debugging solution through CMake wrapper layer
- **[Plugin Development](./11-plugin-development.md)** — SynapticSYS plugin development guide, introducing plugin system architecture, extension point types, and development workflow
- **[ROS2 Integration](./14-ros2-integration.md)** — ROS2 integration approach, usage methods, and configuration options in SynapticSYS

### 📖 User Guide
- **[User Guide](./13-user-guide.md)** — SynapticSYS user guide, including installation, basic concepts, command line tools, and usage examples
---
## 🚀 Quick Start
| Scenario | Recommended Doc | Read Time |
|------|--------|--------|
| First look at SynapticSYS | [Product Analysis](./01-product-analysis.md) | 10 min |
| Understand the core architecture | [Microkernel Services](./03-microkernel-services.md) | 15 min |
| Branding and positioning | [SynapticSYS Naming](./02-naming-analysis.md) | 10 min |
| Plan development timeline | [Development Steps](./12-development-steps.md) | 20 min |
| Technical references | See “Technical Implementation” docs | 15–25 min |
---
## 📊 Document Map
```
Product Positioning (WHAT & WHY)
  ├─ Product Analysis → capabilities, benchmarks, challenges
  └─ SynapticSYS Naming → branding, positioning, validation
Core Architecture (HOW)
  ├─ Microkernel Services → philosophy, service orientation
  ├─ Communication Management → DDS, multi-protocol adapters
  └─ Vision and Architecture → core vision, technical decisions
Technical Implementation (DETAILS)
  ├─ Web HMI Tech Stack → UI framework and frontend
  ├─ Build System → CI/CD, dependencies
  ├─ Virtual Device → hardware abstraction and drivers
  ├─ Builtin Packages → builtin functionality modules design
  ├─ IDE Integration → IDE support, debugging integration
  ├─ Plugin Development → plugin system, extension points, development workflow
  └─ ROS2 Integration → ROS2 integration approach, usage methods, and configuration options
Development Planning (WHEN & WHO)
  └─ Development Steps → four-phase MVP, milestones
User Guide (USAGE)
  └─ User Guide → installation, command line tools, usage examples
```
---
## 🎓 Role-based Reading
### 👨‍💼 Decision-makers / PMs
1. [Product Analysis](./01-product-analysis.md)
2. [SynapticSYS Naming](./02-naming-analysis.md)
3. [Development Steps](./12-development-steps.md) (focus on phases/milestones)
### 🏗️ Architects
1. [Microkernel Services](./03-microkernel-services.md)
2. [Communication Management](./04-communication-management.md)
3. [Development Steps](./12-development-steps.md) (tech choices)
### 💻 Developers
1. [Microkernel Services](./03-microkernel-services.md)
2. [Development Steps](./12-development-steps.md)
3. Tech stack: [Web HMI](./06-web-hmi-tech-stack.md) / [Build Tools](./07-build-tools.md) / [Virtual Device](./08-virtual-device.md) / [Plugin Development](./11-plugin-development.md) / [User Guide](./13-user-guide.md)
### 🧪 QA / Test
1. [Development Steps](./12-development-steps.md) (phase deliverables)
2. [Build Tools](./07-build-tools.md) (CI/CD, automation)
3. [Virtual Device](./08-virtual-device.md) (test env, simulation)
---
## 💡 Quick Reference
| Concept | Definition | Related Doc |
|------|------|--------|
| **Synaptic** | Neurally-inspired distributed system metaphor | [SynapticSYS Naming](./02-naming-analysis.md) |
| **Microkernel** | Minimal kernel + full service orientation | [Microkernel Services](./03-microkernel-services.md) |
| **Synaptic Link** | Unified communication middleware manager | [Communication Management](./04-communication-management.md) |
| **Virtual Device** | Hardware abstraction and device simulation | [Virtual Device](./08-virtual-device.md) |
| **MVP** | Minimum Viable Product, four phases | [Development Steps](./12-development-steps.md) |
---
## 📝 Document Maintenance and Contribution

### Maintenance Guidelines
- **New docs**: use `NN-Title.md` naming convention (NN is a two-digit index number)
- **Update window**: document major decisions within 24 hours
- **Version notes**: record update date and key changes at the top of each document
- **Cross-references**: use Markdown links between related documents
- **Language consistency**: maintain parallel updates for both Chinese and English versions
- **Version control**: commit changes with clear, descriptive messages following Conventional Commits

### Contribution Process
1. **Fork and clone** the repository
2. **Create a branch** for your changes (e.g., `doc-update/architecture-refresh`)
3. **Make your changes**: follow existing style and structure
4. **Review your work**: ensure content is accurate, consistent, and well-formatted
5. **Submit a pull request**: include a clear description of changes
6. **Address feedback**: respond to review comments promptly
7. **Merge**: once approved, your changes will be merged into the main branch

### Style Guidelines
- **Language**: Use clear, concise English; avoid jargon where possible
- **Structure**: Follow the existing document hierarchy and numbering system
- **Formatting**: Use consistent Markdown formatting (headings, lists, code blocks)
- **Links**: Use relative links for internal documents; absolute links for external resources
- **Images**: Place images in an `images/` subdirectory; use descriptive filenames
- **Tables**: Use consistent column alignment and formatting

### Review Process
- **Self-review**: Check for accuracy, completeness, and consistency before submitting
- **Peer review**: All document changes require at least one peer review
- **Technical review**: Architecture-related changes require technical review from the architecture team
- **Approval**: Changes are approved by the document maintainer

---
## 📄 Latest Updates
| Date | Content |
|------|------|
| 2026-01-26 | Enhanced document structure and maintenance guidelines |
| 2026-01-20 | Established doc structure — home/subpages |

