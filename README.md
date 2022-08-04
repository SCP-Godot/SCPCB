# SCP: Godot
An open-source reimagination of SCP - Containment Breach in Godot 4 engine.

## Project details
**SCP: Godot** is an experimental reimagination of SCP - Containment Breach in Godot 4 that utilizes latest features of the engine, such as volumetric lighting, GPU lightmapping, GTAO ambient occlusion and TAA antialiasing.

### Mission statement
The goal of **SCP: Godot** is to create a modern, cross-platform, and open game based around SCP Foundation. Bringing such ambition to life is a great feat, and many past projects failed to accomplish that due to the lack of resources or enormous amounts of time it requires.

With **SCP: Godot** being open-source under a MIT license, we encourage everyone to contribute to the project regardless of a skill level.

### Current state
The project is still in it's infancy, with many features missing.

#### Roadmap
- Player character with blinking and health mechanics.
- Inventory system.
- Port most of Light Containment Zone rooms from Blitz3D to Godot.
- Room generation (C++, through GDExtension).
- Hostile SCPs:
    - SCP-173
    - SCP-049
    - SCP-096
    - SCP-106
- Various SCP items.

### Technical details
- Engine version: `4.0.alpha13`.
- Programming language of choice: **GDScript**, with some systems being written in **C++**.

## Building and running
To build the project, download the [Godot](https://godotengine.org/article/dev-snapshot-godot-4-0-alpha-13) engine and clone the repository to the directory of choice. After completing these steps, opening the project is just a matter of including the project folder in the project inspector.

*CI/CD is being planned to be used to automate releases.*