Language: [中文](./cn/06-网页技术.md) | English

# Web HMI Tech Stack

## Web HMI Technology Research

### 1. Industry Overview

Web HMI (Human-Machine Interface) is a web-based interface for monitoring and controlling industrial devices and systems in the field of industrial automation. It inherits the functionality of traditional HMI while leveraging the flexibility and cross-platform capabilities of web technologies.

Key application scenarios:
- Industrial automation control systems
- Remote equipment monitoring and management
- Production data visualization and analysis
- Energy Management Systems (EMS)
- Smart factories/Intelligent manufacturing

### 2. Mainstream Technical Solutions

#### Siemens Web HMI Solution
- **Tech Stack**: Siemens WinCC Web Navigator, Siemens Industrial Edge
- **Core Features**:
  - Deep integration with Siemens PLCs
  - Real-time data acquisition and visualization
  - Comprehensive security mechanisms
  - Support for edge computing
- **Applicable Scenarios**: Large-scale industrial automation projects with high reliability requirements

#### Web SCADA Technology
- **Representative Products**: Ignition SCADA, Inductive Automation
- **Tech Stack**: Java, HTML5, WebSocket
- **Core Features**:
  - Cross-platform deployment
  - Powerful data processing capabilities
  - Rich visualization components
  - Support for multiple industrial protocols
- **Applicable Scenarios**: Medium-sized industrial automation projects requiring flexible expansion

#### Lightweight Web HMI Solutions
- **Representative Technologies**: Node-RED + Dashboard, MQTT.js + Vue/React
- **Tech Stack**: JavaScript/TypeScript, WebSocket, MQTT
- **Core Features**:
  - Rapid development
  - Low-cost deployment
  - Active community
- **Applicable Scenarios**: Small projects or prototype verification

## Technology Stack Comparison

| Technology Solution | Tech Stack | Performance | Scalability | Development Efficiency | Integration Capability | Applicable Scenarios |
|--------------------|------------|-------------|-------------|------------------------|------------------------|----------------------|
| Siemens Solution | Proprietary | High | Medium | Medium | High (Siemens ecosystem) | Large industrial projects |
| Web SCADA | Java/HTML5 | High | High | Medium | High (multi-protocol support) | Medium industrial projects |
| Lightweight Solutions | JS/Vue/React | Medium | Medium | High | Medium | Small projects/prototypes |
| Blazor Solution | C#/.NET | High | High | High (unified front/back) | High (.NET ecosystem) | Enterprise web applications |
| Modern Web Solutions | TypeScript/React/Vue | High | High | High | Medium | General web applications |

## Technology Direction Based on Project Goals

### 1. Core Technology Selection Recommendations

- **Frontend Framework**: React + TypeScript
  - Mature ecosystem with active community
  - Component-based development for easy maintenance
  - Excellent performance, suitable for complex visualization

- **Real-time Communication**: WebSocket + DDS Gateway
  - WebSocket provides real-time browser-server connection
  - DDS gateway enables integration with backend systems
  - Supports disconnection reconnection and data caching

- **Visualization Libraries**:
  - ECharts: Chart visualization
  - SVG/Canvas: Custom graphics and animations
  - Three.js: 3D equipment model visualization

- **Backend Technology**: .NET Core + SignalR
  - Consistent with project core technology (C#)
  - SignalR provides powerful real-time communication capabilities
  - Supports microservices architecture

### 2. Architecture Design Recommendations

```
┌──────────────────────────────────┐
│ Browser Layer                    │
│ - React + TypeScript Application │
│ - WebSocket Client               │
│ - Visualization Components (ECharts, SVG) │
└──────────────────┬───────────────┘
                   │
┌──────────────────▼───────────────┐
│ Gateway Layer                    │
│ - WebSocket Server               │
│ - DDS Gateway                    │
│ - Data Transformation & Caching  │
└──────────────────┬───────────────┘
                   │
┌──────────────────▼───────────────┐
│ Backend Service Layer            │
│ - .NET Core Microservices        │
│ - DDS Communication Layer        │
│ - Data Processing & Storage      │
└──────────────────┬───────────────┘
                   │
┌──────────────────▼───────────────┐
│ Device Layer                     │
│ - Physical Devices               │
│ - Virtual Devices                │
└──────────────────────────────────┘
```

### 3. Key Function Implementation

- **Real-time Data Monitoring**:
  - Data push using WebSocket
  - Configurable data update frequency
  - Abnormal data alarm and handling

- **Visualization Display**:
  - Device status dashboard
  - Real-time trend charts
  - 3D device models and animations
  - Process visualization

- **Remote Control**:
  - Device operation permission management
  - Operation log recording
  - Emergency stop mechanism

- **Historical Data Query**:
  - Time range query
  - Data export (CSV, PDF)
  - Data analysis and reporting

## Development and Deployment Recommendations

### 1. Development Process

- Use modular development and component reuse
- Adopt CI/CD process for automated testing and deployment
- Establish comprehensive documentation and API specifications

### 2. Deployment Architecture

- Containerized deployment (Docker + Kubernetes)
- Edge deployment support (lightweight containers)
- Load balancing and high availability design

### 3. Performance Optimization

- Frontend performance optimization (lazy loading, code splitting)
- Data compression and caching
- Reasonable update frequency settings
- Server performance monitoring and tuning

## Security Strategy

- Authentication and authorization (OAuth2/OIDC)
- Transport encryption (TLS)
- Device access control
- Operation audit logs
- Anti-cross-site attacks (XSS, CSRF)

## Core Module Designs

### 1. HMI Realtime Dashboard

```csharp
// Pseudocode
@page "/hmi/dashboard"

@if (systemState != null)
{
    <div class="dashboard">
        <div class="gauge">
            <GaugeComponent Value="@systemState.Temperature" />
        </div>
        <div class="chart">
            <LineChartComponent Data="@temperatureHistory" />
        </div>
    </div>
}

@code {
    private SystemState systemState;
    
    protected override async Task OnInitializedAsync()
    {
        // Subscribe DDS topic
        await communication.Subscribe<SystemState>("system/state", state =>
        {
            systemState = state;
            StateHasChanged();
        });
    }
}
```

### 2. Blueprint Editor

**Stack**:
- **Frontend libs**: X6 (graph editor), D3.js
- **Data format**: JSON (nodes, edges, config)
- **Compiler**: in-house or Roslyn (C# compiler API)

**Features**:
- Drag-and-drop nodes
- Connect nodes
- Context menu (delete, edit)
- Undo/redo
- Export to code/config

### 3. UI Editor

**Stack**:
- **Components**: Material (MudBlazor), Bootstrap Blazor
- **Drag/drop**: Blazor DragDrop or in-house
- **Properties panel**: in-house form generator

**Features**:
- Drag components onto canvas
- Edit properties (color, size, events)
- Layout (Grid, Flexbox)
- Responsive preview

### 4. Web Map Integration

**Stack**:
- **Maps**: Leaflet + OSM or Cesium (3D)
- **Data**: GeoJSON, WMS

**Features**:
- Display geolocation
- Realtime device position updates
- Route planning and tracking
- Heatmaps

## Performance and Optimization

### 1. Render Optimization

```csharp
// Update only necessary parts
[CascadingParameter]
public EventCallback<SystemState> OnStateChanged { get; set; }

// Use @key to preserve component state
@foreach (var item in items)
{
    <ItemComponent @key="item.Id" Item="@item" />
}
```

### 2. State Management

Recommended patterns:
- **Fluxor**: Redux-style state management
- **CommunityToolkit.Mvvm**: MVVM toolkit
- **Simple singleton**: sufficient for MVP

### 3. Realtime Communication Best Practices

```csharp
// Proper disposal via IAsyncDisposable
public class RealtimeDataService : IAsyncDisposable
{
    private IDisposable subscription;
    
    public async Task SubscribeToUpdates()
    {
        subscription = await communication.Subscribe<Data>("topic", data =>
        {
            // Handle updates
        });
    }
    
    async ValueTask IAsyncDisposable.DisposeAsync()
    {
        subscription?.Dispose();
    }
}
```

## Security Considerations

### 1. AuthN/AuthZ
- ASP.NET Core Identity
- OAuth 2.0 / OpenID Connect
- JWT token management

### 2. Data Encryption
- HTTPS/TLS (mandatory in production)
- Encrypt sensitive data (passwords, secrets)
- DDS Security for comms

### 3. CORS
```csharp
// Program.cs
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowSynapticClients", policy =>
    {
        policy.WithOrigins("http://localhost:3000", "https://example.com")
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials();
    });
});
```

## Deployment

### Dev Environment
```bash
dotnet watch run
```

### Production
- **Option 1**: Docker containers
    ```dockerfile
    FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
    WORKDIR /app
    COPY . .
    RUN dotnet publish -c Release -o out
  
    FROM mcr.microsoft.com/dotnet/aspnet:8.0
    WORKDIR /app
    COPY --from=build /app/out .
    EXPOSE 5000
    ENTRYPOINT ["dotnet", "SynapticSYS.UI.dll"]
    ```

- **Option 2**: IIS (Windows)
    ```bash
    dotnet publish -c Release -f net8.0
    # Publish to IIS
    ```

- **Option 3**: Kubernetes (scale-out)
    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
        name: synapticsys-ui
    spec:
        replicas: 3
        template:
            spec:
                containers:
                - name: ui
                    image: synapticsys-ui:latest
                    ports:
                    - containerPort: 5000
    ```

## Future Directions

1. **Offline mode**: migrate to Blazor WebAssembly
2. **Mobile**: optimize mobile UI; PWA
3. **Localization**: i18n
4. **Theming**: light/dark, custom palettes
5. **Plugin system**: third-party components

---

---

🔗 [Back to Home](./index.md) | [Development Steps](./12-development-steps.md) | [Build Tools](./07-build-tools.md)