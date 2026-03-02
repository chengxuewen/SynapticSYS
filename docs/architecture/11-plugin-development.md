Language: [中文](./cn/11-插件开发指南.md) | English

# Plugin Development Guide

SynapticSYS uses a flexible plugin architecture that allows developers to extend its functionality by writing custom plugins. This guide will walk you through the process of creating and registering your own plugins.

## Plugin System Architecture

### Core Concepts

- **Extension Points**: Defined interfaces that plugins can implement
- **Plugins**: Concrete implementations of extension points
- **Plugin System**: Manages plugin discovery, loading, and execution

### Extension Point Types

SynapticSYS defines several extension points:

1. **BuildTaskExtensionPoint**: Handles building specific package types
2. **BuildExecutorExtensionPoint**: Manages build execution strategy (sequential/parallel)
3. **PackageDiscoveryExtensionPoint**: Discovers packages in the workspace

## Getting Started

### Plugin Structure

Plugins are Python classes that inherit from one or more extension point classes. They are typically organized as follows:

```
my_plugin/
├── __init__.py
└── my_plugin.py
```

### Creating a Plugin Module

1. Create a directory for your plugin:
   ```bash
   mkdir -p my_plugin
   ```

2. Create an `__init__.py` file:
   ```python
   # Empty file to mark directory as Python package
   ```

## Writing a Build Task Plugin

Build task plugins handle building specific package types. Let's create a simple custom build task plugin.

### Example: Custom Build Task Plugin

```python
from tools.synaptic.plugin.build import BuildTaskExtensionPoint
import subprocess
import click

class MyCustomBuildTask(BuildTaskExtensionPoint):
    """Custom build task plugin"""
    
    PRIORITY = 90  # Lower priority than built-in plugins
    
    def can_handle(self, package_info: dict) -> bool:
        """Check if this plugin can handle the given package"""
        # Check if package has a custom configuration file
        return 'custom_config.yml' in package_info.get('files', [])
    
    def build(self, package_info: dict, build_dir: str, install_dir: str) -> bool:
        """Build the package"""
        try:
            pkg_path = package_info['path']
            pkg_name = package_info['relpath']
            pkg_build_dir = f"{build_dir}/{pkg_name}"
            
            click.echo(f"Building custom package: {pkg_name}")
            
            # Create build directory if it doesn't exist
            import os
            os.makedirs(pkg_build_dir, exist_ok=True)
            
            # Run custom build command
            custom_cmd = [
                'python', '-m', 'custom_build_tool',
                '--source', pkg_path,
                '--build-dir', pkg_build_dir,
                '--install-dir', install_dir
            ]
            
            subprocess.run(custom_cmd, check=True, shell=False)
            return True
        except subprocess.CalledProcessError as e:
            click.echo(f"Error building custom package {pkg_name}: {e}", color='red')
            return False
        except Exception as e:
            click.echo(f"Unexpected error building custom package {pkg_name}: {e}", color='red')
            return False
    
    def clean(self, package_info: dict, build_dir: str) -> bool:
        """Clean the package"""
        try:
            pkg_name = package_info['relpath']
            pkg_build_dir = f"{build_dir}/{pkg_name}"
            
            click.echo(f"Cleaning custom package: {pkg_name}")
            
            # Run custom clean command
            custom_cmd = [
                'python', '-m', 'custom_build_tool',
                '--clean',
                '--build-dir', pkg_build_dir
            ]
            
            subprocess.run(custom_cmd, check=True, shell=False)
            return True
        except subprocess.CalledProcessError as e:
            click.echo(f"Error cleaning custom package {pkg_name}: {e}", color='red')
            return False
        except Exception as e:
            click.echo(f"Unexpected error cleaning custom package {pkg_name}: {e}", color='red')
            return False
```

## Writing a Build Executor Plugin

Build executor plugins manage the build execution strategy. Let's create a custom executor.

### Example: Custom Executor Plugin

```python
from tools.synaptic.plugin.build import BuildExecutorExtensionPoint
import concurrent.futures
from concurrent.futures import Future
import click

class MyCustomExecutor(BuildExecutorExtensionPoint):
    """Custom build executor plugin"""
    
    PRIORITY = 80
    
    def execute(self, build_tasks: list, **kwargs) -> list:
        """Execute build tasks using custom strategy"""
        click.echo("Executing builds with custom executor...")
        
        results = []
        # Custom execution logic here
        
        # Example: Execute tasks with custom thread pool
        with concurrent.futures.ThreadPoolExecutor(max_workers=kwargs.get('jobs', 4)) as executor:
            # Submit all tasks
            futures = [executor.submit(task) for task in build_tasks]
            
            # Collect results
            for future in concurrent.futures.as_completed(futures):
                result = future.result()
                results.append(result)
        
        return results
    
    def shutdown(self) -> None:
        """Shutdown the executor"""
        click.echo("Shutting down custom executor...")
        # Cleanup resources if needed
```

## Writing a Package Discovery Plugin

Package discovery plugins find packages in the workspace. Let's create a custom discovery plugin.

### Example: Custom Package Discovery Plugin

```python
from tools.synaptic.plugin.build import PackageDiscoveryExtensionPoint
import os
import click

class MyCustomDiscovery(PackageDiscoveryExtensionPoint):
    """Custom package discovery plugin"""
    
    PRIORITY = 70
    
    def discover_packages(self, project_root: str) -> list:
        """Discover packages in the workspace"""
        click.echo("Discovering packages with custom discovery...")
        
        src_dir = os.path.join(project_root, 'src')
        packages = []
        
        if not os.path.exists(src_dir):
            return packages
        
        # Custom discovery logic
        for root, dirs, files in os.walk(src_dir):
            # Skip hidden directories
            dirs[:] = [d for d in dirs if not d.startswith('.')]
            
            # Check for custom package indicator
            if 'my_custom_indicator.txt' in files:
                # Extract package info
                pkg_name = os.path.basename(root)
                pkg_relpath = os.path.relpath(root, src_dir)
                
                # Create package info
                pkg_info = {
                    'name': pkg_name,
                    'path': root,
                    'relpath': pkg_relpath,
                    'type': 'custom',
                    'dependencies': [],
                    'files': files
                }
                
                # Extract dependencies from custom file
                custom_deps_file = os.path.join(root, 'my_custom_deps.txt')
                if os.path.exists(custom_deps_file):
                    with open(custom_deps_file, 'r') as f:
                        pkg_info['dependencies'] = [line.strip() for line in f if line.strip()]
                
                packages.append(pkg_info)
        
        return packages
```

## Registering Plugins

### Method 1: Automatic Discovery

Place your plugin in a directory and add that directory to the plugin directories in your configuration:

```yaml
plugins:
  directories:
    - path/to/my_plugin
```

### Method 2: Manual Registration

You can also manually register plugins using the plugin system API:

```python
from tools.synaptic.plugin import get_plugin_system

plugin_system = get_plugin_system()
plugin_system.load_plugin('my_plugin.my_plugin', 'MyCustomBuildTask')
```

## Plugin Loading

Plugins are loaded in the following order:

1. Built-in plugins (highest priority)
2. Custom plugins from configured directories (priority based on PRIORITY attribute)

## Plugin Priority

The `PRIORITY` class attribute determines the order in which plugins are considered:

- Higher priority plugins are checked first for package handling
- Priority values typically range from 0 to 100
- Built-in plugins have priority 100 by default

## Best Practices

### Plugin Development Tips

1. **Keep it simple**: Focus on a single responsibility
2. **Use proper error handling**: Provide clear error messages
3. **Set appropriate priorities**: Consider the order in which your plugin should be used
4. **Document your plugin**: Include docstrings for all public methods
5. **Test your plugin**: Write tests to verify functionality
6. **Follow existing patterns**: Use built-in plugins as reference

### Performance Considerations

- Avoid expensive operations in the `can_handle` method
- Cache results when appropriate
- Use efficient algorithms for package discovery

## Example Plugin Usage

### Configuring Your Plugin

Add your plugin to the synaptic.yaml configuration:

```yaml
plugins:
  directories:
    - my_plugin

build:
  # Your build configuration
```

### Testing Your Plugin

Run the build command to test your plugin:

```bash
synaptic build --verbose
```

## Debugging Plugins

### Enable Debug Logging

```bash
export LOG_LEVEL=DEBUG
synaptic build
```

### Debugging Tips

1. Use `click.echo` for debug output
2. Check the plugin loading logs
3. Verify that your plugin is being discovered
4. Check that your plugin is being called for appropriate packages

## Plugin Examples

### Example 1: Simple Build Task Plugin

```python
from tools.synaptic.plugin.build import BuildTaskExtensionPoint
import subprocess
import click

class SimpleBuildTask(BuildTaskExtensionPoint):
    PRIORITY = 85
    
    def can_handle(self, package_info: dict) -> bool:
        return 'simple_build.txt' in package_info.get('files', [])
    
    def build(self, package_info: dict, build_dir: str, install_dir: str) -> bool:
        pkg_name = package_info['relpath']
        click.echo(f"Building {pkg_name} with simple build task")
        # Simple build logic
        return True
    
    def clean(self, package_info: dict, build_dir: str) -> bool:
        pkg_name = package_info['relpath']
        click.echo(f"Cleaning {pkg_name} with simple build task")
        # Simple clean logic
        return True
```

### Example 2: Custom Executor with Progress Tracking

```python
from tools.synaptic.plugin.build import BuildExecutorExtensionPoint
import concurrent.futures
import click

class ProgressExecutor(BuildExecutorExtensionPoint):
    PRIORITY = 75
    
    def execute(self, build_tasks: list, **kwargs) -> list:
        total_tasks = len(build_tasks)
        completed_tasks = 0
        
        with click.progressbar(length=total_tasks, label="Building packages with progress executor") as progress_bar:
            results = []
            with concurrent.futures.ThreadPoolExecutor(max_workers=kwargs.get('jobs', 4)) as executor:
                futures = [executor.submit(task) for task in build_tasks]
                
                for future in concurrent.futures.as_completed(futures):
                    result = future.result()
                    results.append(result)
                    completed_tasks += 1
                    progress_bar.update(1)
        
        return results
    
    def shutdown(self) -> None:
        pass
```

## Troubleshooting

### Common Issues

1. **Plugin not found**: Check plugin directory configuration
2. **Plugin not being called**: Check priority and `can_handle` implementation
3. **Import errors**: Check Python path and module structure
4. **Duplicate plugins**: Ensure unique plugin names

### Debug Commands

```bash
# Check plugin discovery
synaptic --verbose build

# Verify plugin loading
python -c "from tools.synaptic.plugin import get_plugin_system; ps = get_plugin_system(); print(ps._plugins)"
```

## Advanced Topics

### Multi-Extension Point Plugins

Plugins can implement multiple extension points:

```python
from tools.synaptic.plugin.build import BuildTaskExtensionPoint, PackageDiscoveryExtensionPoint

class MultiExtensionPlugin(BuildTaskExtensionPoint, PackageDiscoveryExtensionPoint):
    PRIORITY = 80
    
    def can_handle(self, package_info: dict) -> bool:
        # Build task implementation
        pass
    
    def build(self, package_info: dict, build_dir: str, install_dir: str) -> bool:
        # Build implementation
        pass
    
    def clean(self, package_info: dict, build_dir: str) -> bool:
        # Clean implementation
        pass
    
    def discover_packages(self, project_root: str) -> list:
        # Discovery implementation
        pass
```

### Plugin Dependencies

Plugins can have dependencies on other plugins or external libraries:

```python
from tools.synaptic.plugin.build import BuildTaskExtensionPoint
import external_library

class PluginWithDependencies(BuildTaskExtensionPoint):
    PRIORITY = 90
    
    def can_handle(self, package_info: dict) -> bool:
        # Check if external library is available
        try:
            import external_library
            return True
        except ImportError:
            return False
    
    def build(self, package_info: dict, build_dir: str, install_dir: str) -> bool:
        # Use external library
        external_library.do_something()
        return True
    
    def clean(self, package_info: dict, build_dir: str) -> bool:
        return True
```

## Conclusion

The SynapticSYS plugin system provides a powerful way to extend the build system's functionality. By following this guide, you can create custom plugins to support new package types, build strategies, and discovery mechanisms.

For more examples, refer to the built-in plugins in the `tools/synaptic/plugin/builtin` directory.

Happy plugin development!