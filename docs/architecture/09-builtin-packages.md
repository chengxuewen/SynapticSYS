# 内置预设包设计

## 1. 设计目标

- 提供类似ROS的内置预设包，方便开发者快速构建应用
- 支持多种编程语言（Python、C++、C#）
- 与FastDDS无缝集成，提供简化的通信API
- 遵循模块化设计原则，便于扩展和维护
- 保持与ROS API风格的兼容性，降低学习曲线

## 2. 目录结构

内置预设包采用与外部包相同的目录结构，存放在项目根目录的`packages/`目录中：

```
SynapticSYS/
├── packages/                 # 内置预设包目录
│   ├── synpy/                # Python内置包
│   │   ├── setup.py
│   │   └── synpy/
│   │       ├── __init__.py
│   │       ├── node.py
│   │       ├── publisher.py
│   │       ├── subscriber.py
│   │       └── service.py
│   ├── syncpp/               # C++内置包
│   │   ├── CMakeLists.txt
│   │   ├── include/
│   │   │   └── syncpp/
│   │   └── src/
│   ├── synmsg/               # 消息定义包
│   │   ├── CMakeLists.txt
│   │   └── msg/
│   └── synutils/             # 工具函数包
│       ├── setup.py
│       └── synutils/
└── src/                      # 外部用户包目录
```

## 3. 内置包列表

### 3.1 synpy

Python内置包，提供简化的FastDDS通信API：
- `synpy.Node` - 节点基类
- `synpy.Publisher` - 发布者类
- `synpy.Subscriber` - 订阅者类
- `synpy.Service` - 服务类
- `synpy.ServiceClient` - 服务客户端类

### 3.2 syncpp

C++内置包，提供高效的FastDDS通信API：
- `syncpp::Node` - 节点基类
- `syncpp::Publisher` - 发布者模板类
- `syncpp::Subscriber` - 订阅者模板类
- `syncpp::Service` - 服务模板类
- `syncpp::ServiceClient` - 服务客户端模板类

### 3.3 synmsg

消息定义包，包含常用的标准消息类型：
- 基本数据类型（String、Int32、Float64等）
- 几何数据类型（Point、Pose、Transform等）
- 传感器数据类型（LaserScan、Image等）
- 诊断数据类型

### 3.4 synutils

通用工具包，提供各种辅助功能：
- 时间工具
- 日志工具
- 配置管理
- 类型转换
- 字符串处理

## 4. 实现机制

### 4.1 包发现

内置包通过修改包发现机制实现：
- 在`tools/synaptic/builder/builder.py`中修改`_discover_packages`方法
- 在`tools/synaptic/plugin/builtin/default_discovery.py`中更新`discover_packages`方法
- 支持同时从`packages/`（内置）和`src/`（外部）目录发现包

### 4.2 构建流程

内置包的构建流程与外部包相同：
- 包发现阶段识别所有内置包
- 依赖分析阶段处理包间依赖
- 拓扑排序确定构建顺序
- 并行构建阶段编译所有包
- 安装阶段将包安装到指定目录

### 4.3 环境变量

内置包构建完成后，会自动添加到环境变量中：
- Python包路径添加到`PYTHONPATH`
- C++包头文件路径添加到`CPATH`
- 库文件路径添加到`LD_LIBRARY_PATH`（Linux）或`DYLD_LIBRARY_PATH`（macOS）

## 5. ROS兼容性

内置预设包设计考虑了与ROS的兼容性：
- API风格尽量接近ROS，降低迁移成本
- 支持类似的节点、发布者、订阅者概念
- 消息类型命名规则与ROS保持一致
- 提供工具支持ROS消息到内置消息的转换

## 6. 扩展机制

内置预设包支持扩展：
- 开发者可以通过插件机制添加新的内置包类型
- 支持自定义包发现逻辑
- 允许替换现有内置包的实现

## 7. 测试策略

内置预设包的测试策略：
- 单元测试：测试各个组件的基本功能
- 集成测试：测试包间交互
- 性能测试：评估通信性能
- 兼容性测试：确保与外部包兼容

## 8. 未来规划

- 添加更多内置包，覆盖常用功能
- 增强与ROS的兼容性
- 提供更丰富的文档和示例
- 支持动态加载内置包
- 优化内置包的性能
