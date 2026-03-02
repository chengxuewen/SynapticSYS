Language: [中文](./cn/08-虚拟设备.md) | English

# Virtual Device

## Core Concepts

### What is Virtual Device

**Virtual Device** is the hardware abstraction layer in SynapticSYS, responsible for:

1. **Unified device interfaces** for diverse hardware
2. **Virtual/real switching**: use virtual devices in dev/test; real hardware in production
3. **Hot-plug support**: dynamic connect/disconnect; auto discovery and adaptation

## Virtual Device Technology Research

### Industry Overview

Virtual device technology has evolved significantly in recent years, driven by:

- **DevOps practices**: Need for consistent development/testing environments
- **IoT proliferation**: Growing number of device types and protocols
- **Edge computing**: Requirements for device simulation at the edge
- **Cloud integration**: Bridging physical and digital worlds

### Key Technologies

#### 1. Device Abstraction Layer

```
┌──────────────────────────────────┐
│ Application Layer                │
└──────────────────┬───────────────┘
                   │
┌──────────────────▼───────────────┐
│ Device Abstraction Layer         │
│ - Unified APIs                   │
│ - Protocol translation           │
│ - Device management              │
└──────────────────┬───────────────┘
                   │
┌──────────────────┴───────────────┐
│ Hardware Layer                   │
│ - Real devices                   │
│ - Virtual devices                │
└──────────────────────────────────┘
```

#### 2. Virtualization Technologies

| Technology | Description | Use Cases |
|------------|-------------|-----------|
| **Emulation** | Full hardware simulation | Legacy device support |
| **Virtualization** | Shared hardware resources | Resource optimization |
| **Containerization** | Lightweight isolation | Cross-platform compatibility |
| **Digital Twins** | Real-time device mirroring | Predictive maintenance |

#### 3. Industry Solutions

- **ROS2 Gazebo**: Robot simulation environment
- **QEMU**: Hardware emulator and virtualizer
- **Docker Devices**: Container device virtualization
- **Azure IoT Device Simulator**: Cloud-based device simulation

### Technical Challenges

1. **Real-time performance**: Virtual devices must match real device latency
2. **Protocol compatibility**: Support for diverse communication protocols (CAN, MODBUS, etc.)
3. **State synchronization**: Maintaining consistent state between virtual and real devices
4. **Scalability**: Supporting hundreds/thousands of virtual devices
5. **Security**: Protecting device communication and data

## Development Direction for SynapticSYS

### Core Objectives

1. **Unified abstraction**: Single API for all device interactions
2. **Seamless switching**: Between virtual and real devices without code changes
3. **Rich simulation**: Realistic device behavior modeling
4. **Performance optimization**: Real-time response guarantees
5. **Extensibility**: Easy addition of new device types and protocols

### Technical Architecture Evolution

#### Phase 1: Foundation Layer

```
┌──────────────────────────────────┐
│ Device Abstraction API (C#)      │
│ - IInputDevice, IOutputDevice    │
│ - ISensorDevice, IActuatorDevice  │
└──────────────────┬───────────────┘
                   │
┌──────────────────▼───────────────┐
│ Device Manager                   │
│ - Device registration            │
│ - Virtual/real switching         │
│ - Hot-plug management            │
└──────────────────┬───────────────┘
                   │
┌──────────────────▼───────────────┐
│ Basic Device Drivers             │
│ - USB, GPIO, Serial              │
│ - Simple virtual devices         │
└──────────────────────────────────┘
```

#### Phase 2: Advanced Simulation

```
┌──────────────────────────────────┐
│ Enhanced Device Models           │
│ - Physics-based simulation       │
│ - Sensor data generation         │
│ - Actuator response modeling     │
└──────────────────┬───────────────┘
                   │
┌──────────────────▼───────────────┐
│ Protocol Adapters                │
│ - CAN bus emulation              │
│ - Modbus TCP/RTU                 │
│ - MQTT/DDS integration           │
└──────────────────┬───────────────┘
                   │
┌──────────────────▼───────────────┐
│ Scenario Engine                  │
│ - Complex interaction scenarios  │
│ - Error injection capabilities   │
│ - Data playback/recording        │
└──────────────────────────────────┘
```

#### Phase 3: Intelligent Integration

```
┌──────────────────────────────────┐
│ AI-Enhanced Simulation           │
│ - Machine learning-based modeling│
│ - Predictive behavior simulation │
└──────────────────┬───────────────┘
                   │
┌──────────────────▼───────────────┐
│ Digital Twin Integration         │
│ - Real-time synchronization      │
│ - Cloud-based device mirroring   │
└──────────────────┬───────────────┘
                   │
┌──────────────────▼───────────────┐
│ Edge Computing Support           │
│ - Edge device simulation         │
│ - Distributed deployment         │
└──────────────────────────────────┘
```

## Technical Roadmap

### Short-term (0-6 months)

1. **Core API development**
   - Define unified device interfaces
   - Implement basic device manager

2. **Basic device support**
   - USB input devices (keyboard, mouse, gamepad)
   - GPIO digital I/O
   - Simple virtual sensors

3. **Virtual/real switching**
   - Configuration-based device selection
   - Hot-plug detection and handling

### Medium-term (6-12 months)

1. **Advanced protocols**
   - CAN bus emulation and support
   - Modbus TCP/RTU integration
   - Serial port (RS-232/485) support

2. **Rich simulation capabilities**
   - Physics-based sensor models
   - Actuator response simulation
   - Data recording and playback

3. **Scenario engine**
   - Complex interaction scenario definition
   - Error injection for testing

### Long-term (12+ months)

1. **AI integration**
   - Machine learning-based device behavior modeling
   - Predictive simulation capabilities

2. **Digital twin support**
   - Real-time synchronization with physical devices
   - Cloud-based device mirroring

3. **Edge computing**
   - Edge device simulation
   - Distributed device management

4. **Ecosystem expansion**
   - SDK for third-party device integration
   - Device marketplace for virtual device models

## Architecture

### Layered Model

### Supported Device Types

- **Inputs**: steering wheel, joystick, touch, keyboard, mouse
- **I/O modules**: digital I/O, analog I/O, PWM
- **Comms**: CAN, RS‑485, USB, Ethernet
- **Sensors**: GPS, IMU, radar, camera
- **Actuators**: motors, relays, solenoids

## Architecture

### Layered Model

```
┌─────────────────────────────────────┐
│   上层应用（蓝图编辑器、HMI 等）      │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│      VDS 统一接口层 (C# API)        │
│  IInputDevice, IOutputDevice 等      │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│   适配器层（Adapter Pattern）        │
│  ┌──────────┬──────────┬──────────┐ │
│  │ CAN 适配 │ USB 适配 │ GPIO 适配│ │
│  └──────────┴──────────┴──────────┘ │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│  硬件驱动层（Native / System Call）  │
│  Windows: WinUSB, SetupAPI          │
│  Linux: libusb, sysfs              │
└─────────────────────────────────────┘
```

### Core Interfaces

```csharp
/// <summary>
/// Base device interface implemented by all devices
/// </summary>
public interface IDevice
{
    /// <summary>Unique device identifier</summary>
    string DeviceId { get; }
    
    /// <summary>Device name</summary>
    string DeviceName { get; }
    
    /// <summary>Device type</summary>
    DeviceType Type { get; }
    
    /// <summary>Is connected</summary>
    bool IsConnected { get; }
    
    /// <summary>Connect device</summary>
    Task<bool> Connect();
    
    /// <summary>Disconnect device</summary>
    Task<bool> Disconnect();
}

/// <summary>Input device (reads data)</summary>
public interface IInputDevice : IDevice
{
    /// <summary>Read non-blocking</summary>
    bool TryRead(out DeviceData data);
    
    /// <summary>Subscribe to data change events</summary>
    event EventHandler<DeviceDataEventArgs> DataReceived;
}

/// <summary>Output device (writes data)</summary>
public interface IOutputDevice : IDevice
{
    /// <summary>Write data</summary>
    Task<bool> Write(DeviceData data);
}

/// <summary>Generic device data format</summary>
public class DeviceData
{
    public string DeviceId { get; set; }
    public long Timestamp { get; set; }  // Millisecond timestamp
    public Dictionary<string, object> Values { get; set; }
}
```

## Drivers

### Example 1: USB Device Driver

```csharp
public class USBDevice : IInputDevice
{
    private SafeFileHandle handle;
    private byte[] buffer;
    
    public string DeviceId { get; private set; }
    public string DeviceName { get; private set; }
    public bool IsConnected { get; private set; }
    
    public async Task<bool> Connect()
    {
        try
        {
            // Enumerate devices via SetupAPI
            var devices = UsbHelper.FindDevices(deviceVid, devicePid);
            if (devices.Count == 0) return false;
            
            // Open device
            handle = UsbHelper.OpenDevice(devices[0]);
            IsConnected = true;
            
            // Start read loop
            _ = ReadLoop();
            return true;
        }
        catch { return false; }
    }
    
    public event EventHandler<DeviceDataEventArgs> DataReceived;
    
    private async Task ReadLoop()
    {
        while (IsConnected)
        {
            try
            {
                int bytesRead = await ReadAsync(handle, buffer, buffer.Length);
                
                var data = new DeviceData
                {
                    DeviceId = DeviceId,
                    Timestamp = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds(),
                    Values = ParseBuffer(buffer, bytesRead)
                };
                
                DataReceived?.Invoke(this, new DeviceDataEventArgs { Data = data });
            }
            catch (Exception ex)
            {
                // Logging
                Debug.WriteLine($"USB read error: {ex}");
            }
            
            await Task.Delay(10);  // 100Hz sampling
        }
    }
}
```

### Example 2: Virtual Device Driver

```csharp
public class VirtualSteeringWheel : IInputDevice
{
    private readonly Random _random = new();
    private CancellationTokenSource _cts;
    
    public string DeviceId => "virtual-steering-wheel-001";
    public string DeviceName => "Virtual Steering Wheel (Simulated)";
    public bool IsConnected { get; private set; }
    
    public async Task<bool> Connect()
    {
        IsConnected = true;
        _cts = new CancellationTokenSource();
        
        // Simulate data generation
        _ = SimulateData(_cts.Token);
        return await Task.FromResult(true);
    }
    
    public event EventHandler<DeviceDataEventArgs> DataReceived;
    
    private async Task SimulateData(CancellationToken ct)
    {
        var angle = 0.0;
        
        while (!ct.IsCancellationRequested)
        {
            // Simulate random steering movement
            angle += _random.Next(-5, 6);
            angle = Math.Clamp(angle, -180, 180);
            
            var data = new DeviceData
            {
                DeviceId = DeviceId,
                Timestamp = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds(),
                Values = new() { { "angle", angle } }
            };
            
            DataReceived?.Invoke(this, new DeviceDataEventArgs { Data = data });
            
            await Task.Delay(50);  // 20Hz sampling
        }
    }
}
```

## Device Management and Discovery

### Auto Discovery

```csharp
public class DeviceManager
{
    private Dictionary<string, IDevice> _devices = new();
    private List<IDeviceFactory> _factories = new();
    
    public event EventHandler<DeviceEventArgs> DeviceConnected;
    public event EventHandler<DeviceEventArgs> DeviceDisconnected;
    
    public void RegisterFactory(IDeviceFactory factory)
    {
        _factories.Add(factory);
    }
    
    public async Task StartDeviceDiscovery()
    {
        while (true)
        {
            // Scan devices from all registered factories
            foreach (var factory in _factories)
            {
                var availableDevices = await factory.ScanDevices();
                
                foreach (var deviceInfo in availableDevices)
                {
                    if (!_devices.ContainsKey(deviceInfo.DeviceId))
                    {
                        // New device detected
                        var device = await factory.CreateDevice(deviceInfo);
                        if (await device.Connect())
                        {
                            _devices[deviceInfo.DeviceId] = device;
                            DeviceConnected?.Invoke(this, new DeviceEventArgs { Device = device });
                        }
                    }
                }
            }
            
            // Detect disconnected devices
            var disconnected = new List<string>();
            foreach (var deviceId in _devices.Keys)
            {
                if (!_devices[deviceId].IsConnected)
                {
                    disconnected.Add(deviceId);
                }
            }
            
            foreach (var deviceId in disconnected)
            {
                var device = _devices[deviceId];
                _devices.Remove(deviceId);
                DeviceDisconnected?.Invoke(this, new DeviceEventArgs { Device = device });
            }
            
            await Task.Delay(1000);  // Scan every second
        }
    }
}
```

## Configuration

### VDS YAML Config

```yaml
# vds-config.yaml
devices:
  - id: "steering-wheel-001"
    name: "Main Steering Wheel"
    type: "input"
    driver: "usb"
    enabled: true
    config:
      vid: 0x1234
      pid: 0x5678
      sampleRate: 100  # Hz
  
  - id: "throttle-001"
    name: "Throttle Pedal"
    type: "input"
    driver: "can"
    enabled: true
    config:
      canInterface: "can0"
      canId: 0x123
  
  - id: "virtual-wheel-dev"
    name: "Virtual Wheel (Development)"
    type: "input"
    driver: "virtual"
    enabled: false
    config:
      sampleRate: 20  # Hz
      noiseLevel: 5   # degrees
```

### Config Loading

```csharp
public class VdsConfiguration
{
    public static async Task<DeviceManager> LoadFromFile(string configPath)
    {
        var manager = new DeviceManager();
        
        var yaml = await File.ReadAllTextAsync(configPath);
        var config = YamlConvert.DeserializeObject<VdsConfig>(yaml);
        
        // Register driver factories
        manager.RegisterFactory(new USBDeviceFactory());
        manager.RegisterFactory(new CANDeviceFactory());
        manager.RegisterFactory(new VirtualDeviceFactory());
        
        // Initialize configured devices
        foreach (var deviceConfig in config.Devices.Where(d => d.Enabled))
        {
            // Device initialization logic
        }
        
        return manager;
    }
}
```

## Integration with Microkernel

### Service Exposure

```csharp
// VDS 作为一个服务，被微内核管理
public class VirtualDeviceService : IService
{
    private DeviceManager _deviceManager;
    
    public async Task Start()
    {
        _deviceManager = await VdsConfiguration.LoadFromFile("vds-config.yaml");
        await _deviceManager.StartDeviceDiscovery();
    }
    
    public async Task Stop()
    {
        // 关闭所有设备
    }
    
    // Expose APIs for other services
    [ServiceApi("vds/read")]
    public async Task<DeviceData> ReadData(string deviceId)
    {
        return _deviceManager.GetDevice(deviceId)?.GetLatestData();
    }
    
    [ServiceApi("vds/write")]
    public async Task WriteData(string deviceId, DeviceData data)
    {
        var device = _deviceManager.GetDevice(deviceId) as IOutputDevice;
        await device?.Write(data);
    }
}
```

## Testing and Simulation

### Unit Tests

```csharp
[TestClass]
public class VDSTests
{
    [TestMethod]
    public async Task TestVirtualSteeringWheelSimulation()
    {
        var wheel = new VirtualSteeringWheel();
        
        var connected = await wheel.Connect();
        Assert.IsTrue(connected);
        
        // Listen to data
        int dataCount = 0;
        wheel.DataReceived += (s, e) => dataCount++;
        
        await Task.Delay(500);
        
        // Should receive at least 10 data points (20Hz)
        Assert.IsTrue(dataCount >= 10);
    }
}
```

### Hardware-in-the-Loop (HIL) Simulation

Tools:
- **CARLA** - autonomous vehicle sim
- **Gazebo** - robotics sim
- **dSPACE ModelDesk** - control systems sim

Integration example:
```csharp
// 通过 VDS 连接到 CARLA 仿真器
var carlaBridge = new CarlaVDSBridge();
var manager = new DeviceManager();
manager.RegisterFactory(carlaBridge);
```

## Future Extensions

1. **Networked devices**: remote devices over network
2. **Device aggregation**: combine multiple physical devices
3. **Record & replay**: capture inputs for playback tests
4. **Data conversion**: auto convert formats across devices
5. **Performance monitoring**: latency and throughput tracking

---

---

🔗 [Back to Home](./index.md) | [Build Tools](./07-build-tools.md)