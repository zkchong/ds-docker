# Running DS Docker on Windows 11 from WSL
This project builds a docker that runs a Jupyterlab on Windows 11 from WSL using Podman.

## Installation Instruction

### Install WSL 2
- Open PowerShell or Command Prompt as Administrator:
Right-click "Start" > "Windows Terminal (Admin)" or search for "PowerShell" or "Command Prompt", then right-click and select "Run as administrator".

- Type the following command and press Enter: `wsl --install`
- You may need to setup the adminstrator account. Do accordingly.
- After the process completes, restart your PC when prompted.

### Install Podman in WSL
Go into the WSL using the Windows' Start Menu.
When inside, run 
```bash
sudo apt update
sudo apt upgrade  # Always a good idea to keep the OS updated.

# Install packages
sudo install podman just

# Test podman is installed successfully.
podman run hello-world
```

### Run Docker
Run:
```bash
just docker-run
```
## Cursor AI
Note that you may need to setup the WSL extension when using WSL with Cursor.