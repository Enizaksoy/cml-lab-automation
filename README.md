# Cisco CML Lab Automation with AI

Automate Cisco Modeling Labs (CML) device configuration using AI tools (Claude). This project demonstrates how to programmatically configure NX-OS 9000v switches in a VXLAN EVPN spine-leaf topology.

![Lab Topology](images/cml_topology.jpg)

## Overview

This repository contains scripts and documentation for:
- Accessing Cisco CML via API and console
- Automated NX-OS device configuration (hostname, management IP, SSH, users)
- MobaXterm session management
- Expect scripts for bulk device provisioning

## Lab Topology

**Architecture:** 3-Tier Clos (Super-Spine / Spine / Leaf)

| Device | Role | Management IP |
|--------|------|---------------|
| Super-Spine-1 | Super Spine | 192.168.30.118 |
| Super-Spine-2 | Super Spine | 192.168.30.119 |
| Spine-1 | Spine | 192.168.30.110 |
| Spine-2 | Spine | 192.168.30.111 |
| Spine-3 | Spine | 192.168.30.112 |
| Spine-4 | Spine | 192.168.30.113 |
| Leaf-1 | Leaf | 192.168.30.114 |
| Leaf-2 | Leaf | 192.168.30.115 |
| Leaf-3 | Leaf | 192.168.30.116 |
| Leaf-4 | Leaf | 192.168.30.117 |

## Quick Start

### Prerequisites
- Cisco CML 2.x installed and running
- `expect` package installed (`apt install expect`)
- GitHub CLI (`gh`) for repository management
- MobaXterm (optional, for Windows SSH client)

### 1. Clone Repository
```bash
git clone https://github.com/Enizaksoy/cml-lab-automation.git
cd cml-lab-automation
```

### 2. Configure Variables
Edit `scripts/config_device.exp` and update:
```tcl
# CML Server
set cml_host "192.168.20.65"
set cml_user "admin"
set cml_pass "your-cml-password"

# Device credentials to create
set device_user "admin"
set device_pass "your-device-password"
```

### 3. Run Automation
```bash
# Configure a single device
./scripts/config_device.exp Spine-1 192.168.30.110

# Configure all devices
./scripts/configure_all.sh
```

## Project Structure

```
cml-lab-automation/
├── README.md
├── images/
│   └── cml_topology.jpg
├── scripts/
│   ├── config_device.exp      # Expect script for single device
│   └── configure_all.sh       # Batch configuration script
├── configs/
│   └── nxos_base_config.txt   # NX-OS configuration template
└── docs/
    └── mobaxterm_setup.md     # MobaXterm configuration guide
```

## How It Works

### Step 1: Connect to CML Console Server
```bash
ssh admin@192.168.20.65
# At consoles> prompt:
open /LAB_NAME/DEVICE_NAME/0
```

### Step 2: Apply Configuration
The expect script sends these commands to each NX-OS device:
```
configure terminal
hostname <device-name>
interface mgmt0
  ip address <ip>/24
  no shutdown
vrf context management
  ip route 0.0.0.0/0 <gateway>
feature ssh
username admin password <password> role network-admin
end
copy running-config startup-config
```

### Step 3: Verify Access
```bash
ssh admin@192.168.30.110
# Password: <configured-password>
```

## CML API Reference

### Authentication
```bash
TOKEN=$(curl -sk -X POST https://<CML_IP>/api/v0/authenticate \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"<password>"}' | tr -d '"')
```

### List Labs
```bash
curl -sk https://<CML_IP>/api/v0/labs \
  -H "Authorization: Bearer $TOKEN"
```

### Get Lab Nodes
```bash
curl -sk https://<CML_IP>/api/v0/labs/<LAB_ID>/nodes \
  -H "Authorization: Bearer $TOKEN"
```

## MobaXterm Integration

To add sessions to MobaXterm programmatically:

1. **Close MobaXterm**
2. Edit `%APPDATA%\MobaXterm\MobaXterm.ini`
3. Add bookmark sections (see [MobaXterm Setup Guide](docs/mobaxterm_setup.md))
4. Reopen MobaXterm

## Using with AI Tools

This workflow was created using Claude (AI assistant). To replicate for your own lab:

### Provide This Information:
```
1. CML Server: IP, username, password
2. Lab Name: Name of your CML lab
3. IP Range: Management IPs for devices (e.g., 192.168.30.110-120)
4. Gateway: Default gateway for management VRF
5. Device Credentials: Username/password to create on devices
```

### Example AI Prompt:
```
Configure my CML lab "DATACENTER_LAB" at 192.168.20.65 (admin/mypassword).
- Assign management IPs 10.0.0.10-25 with gateway 10.0.0.1
- Create user "netops" with password "SecurePass123!"
- Add SSH sessions to MobaXterm under "DC_Switches" folder
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Cannot SSH to device | Verify device is BOOTED in CML, check `show ip int brief vrf management` |
| Expect script timeout | Increase timeout value, check CML console connectivity |
| MobaXterm sessions missing | Ensure MobaXterm was closed before editing INI file |
| Authentication failed | Verify credentials, check if user was created with correct role |

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-topology`)
3. Commit changes (`git commit -am 'Add new topology support'`)
4. Push to branch (`git push origin feature/new-topology`)
5. Open a Pull Request

## License

MIT License - feel free to use and modify for your own labs.

## Author

Created by [Enizaksoy](https://github.com/Enizaksoy) using Claude AI for network automation.

---

**Keywords:** Cisco CML, Network Automation, NX-OS, VXLAN EVPN, Spine-Leaf, Infrastructure as Code, AI-Assisted Automation
