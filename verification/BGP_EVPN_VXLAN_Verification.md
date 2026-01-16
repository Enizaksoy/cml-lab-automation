# BGP EVPN VXLAN Configuration Verification

**Date:** January 16, 2026
**Lab:** VXLAN_MANUAL (Cisco CML)

## Configuration Status Summary

| Device | Management IP | BGP AS | Role | Config Status |
|--------|---------------|--------|------|---------------|
| Super-Spine-1 | 192.168.30.118 | 65000 | Route Reflector | ✅ Applied |
| Super-Spine-2 | 192.168.30.119 | 65000 | Route Reflector | ✅ Applied |
| Spine-1 | 192.168.30.110 | 65001 | Aggregation | ✅ Applied |
| Spine-2 | 192.168.30.111 | 65002 | Aggregation | ✅ Applied |
| Spine-3 | 192.168.30.112 | 65003 | Aggregation | ✅ Applied |
| Spine-4 | 192.168.30.113 | 65004 | Aggregation | ✅ Applied |
| Leaf-1 | 192.168.30.114 | 65101 | VTEP | ✅ Applied |
| Leaf-2 | 192.168.30.115 | 65102 | VTEP | ✅ Applied |
| Leaf-3 | 192.168.30.116 | 65103 | VTEP | ✅ Applied |
| Leaf-4 | 192.168.30.117 | 65104 | VTEP | ✅ Applied |

---

## Super-Spine-1 Verification

### BGP Configuration
```
Super-Spine-1# show running-config bgp

router bgp 65000
  router-id 10.0.0.1
  bestpath as-path multipath-relax
  log-neighbor-changes
  address-family ipv4 unicast
    redistribute direct route-map PERMIT-ALL
    maximum-paths 64
  address-family l2vpn evpn
    retain route-target all
  neighbor 10.1.1.1
    remote-as 65001
    description Spine-1
    address-family ipv4 unicast
    address-family l2vpn evpn
      send-community extended
      route-map UNCHANGED out
  neighbor 10.1.1.3
    remote-as 65002
    description Spine-2
    address-family ipv4 unicast
    address-family l2vpn evpn
      send-community extended
      route-map UNCHANGED out
  neighbor 10.1.1.5
    remote-as 65003
    description Spine-3
    address-family ipv4 unicast
    address-family l2vpn evpn
      send-community extended
      route-map UNCHANGED out
  neighbor 10.1.1.7
    remote-as 65004
    description Spine-4
    address-family ipv4 unicast
    address-family l2vpn evpn
      send-community extended
      route-map UNCHANGED out
```

### Interface Status
```
Super-Spine-1# show ip interface brief

Interface            IP Address      Interface Status
Lo0                  10.0.0.1        protocol-up/link-up/admin-up
Eth1/1               10.1.1.0        protocol-up/link-up/admin-up
Eth1/2               10.1.1.2        protocol-up/link-up/admin-up
Eth1/3               10.1.1.4        protocol-up/link-up/admin-up
Eth1/4               10.1.1.6        protocol-up/link-up/admin-up
```

---

## Spine-1 Verification

### BGP Configuration
```
Spine-1# show running-config bgp

router bgp 65001
  router-id 10.0.1.1
  bestpath as-path multipath-relax
  log-neighbor-changes
  address-family ipv4 unicast
    redistribute direct route-map PERMIT-ALL
    maximum-paths 64
  address-family l2vpn evpn
    retain route-target all
  neighbor 10.1.1.0
    remote-as 65000
    description Super-Spine-1
    address-family ipv4 unicast
    address-family l2vpn evpn
      send-community extended
  neighbor 10.1.1.8
    remote-as 65000
    description Super-Spine-2
    address-family ipv4 unicast
    address-family l2vpn evpn
      send-community extended
  neighbor 10.2.1.1
    remote-as 65101
    description Leaf-1
    address-family ipv4 unicast
    address-family l2vpn evpn
      send-community extended
      route-map UNCHANGED out
  neighbor 10.2.1.3
    remote-as 65102
    description Leaf-2
    address-family ipv4 unicast
    address-family l2vpn evpn
      send-community extended
      route-map UNCHANGED out
  neighbor 10.2.1.5
    remote-as 65103
    description Leaf-3
    address-family ipv4 unicast
    address-family l2vpn evpn
      send-community extended
      route-map UNCHANGED out
  neighbor 10.2.1.7
    remote-as 65104
    description Leaf-4
    address-family ipv4 unicast
    address-family l2vpn evpn
      send-community extended
      route-map UNCHANGED out
```

### Interface Status
```
Spine-1# show ip interface brief

Interface            IP Address      Interface Status
Lo0                  10.0.1.1        protocol-up/link-up/admin-up
Eth1/1               10.2.1.0        protocol-up/link-up/admin-up
Eth1/2               10.2.1.2        protocol-up/link-up/admin-up
Eth1/3               10.2.1.4        protocol-up/link-up/admin-up
Eth1/4               10.2.1.6        protocol-up/link-up/admin-up
Eth1/5               10.1.1.1        protocol-up/link-up/admin-up
Eth1/6               10.1.1.9        protocol-up/link-up/admin-up
```

---

## Leaf-1 Verification

### BGP Configuration
```
Leaf-1# show running-config bgp

router bgp 65101
  router-id 10.0.2.1
  bestpath as-path multipath-relax
  log-neighbor-changes
  address-family ipv4 unicast
    redistribute direct route-map PERMIT-ALL
    maximum-paths 64
  address-family l2vpn evpn
  neighbor 10.2.1.0
    remote-as 65001
    description Spine-1
    address-family ipv4 unicast
    address-family l2vpn evpn
      send-community extended
  neighbor 10.2.2.0
    remote-as 65002
    description Spine-2
    address-family ipv4 unicast
    address-family l2vpn evpn
      send-community extended
  neighbor 10.2.3.0
    remote-as 65003
    description Spine-3
    address-family ipv4 unicast
    address-family l2vpn evpn
      send-community extended
  neighbor 10.2.4.0
    remote-as 65004
    description Spine-4
    address-family ipv4 unicast
    address-family l2vpn evpn
      send-community extended
  vrf mylab
    address-family ipv4 unicast
      advertise l2vpn evpn
      redistribute direct route-map PERMIT-ALL
      maximum-paths 64
```

### EVPN Configuration
```
Leaf-1# show running-config evpn

evpn
  vni 10010 l2
    rd auto
    route-target import auto
    route-target export auto
  vni 10020 l2
    rd auto
    route-target import auto
    route-target export auto
  vni 10030 l2
    rd auto
    route-target import auto
    route-target export auto
  vni 10040 l2
    rd auto
    route-target import auto
    route-target export auto
```

### VXLAN VNI Status
```
Leaf-1# show nve vni

Interface VNI      Multicast-group   State Mode Type [BD/VRF]      Flags
--------- -------- ----------------- ----- ---- ------------------ -----
nve1      10010    UnicastBGP        Down  CP   L2 [10]
nve1      10020    UnicastBGP        Down  CP   L2 [20]
nve1      10030    UnicastBGP        Down  CP   L2 [30]
nve1      10040    UnicastBGP        Down  CP   L2 [40]
nve1      50000    n/a               Down  CP   L3 [mylab]
```

### VXLAN VLAN Mapping
```
Leaf-1# show vxlan

Vlan            VN-Segment
====            ==========
10              10010
20              10020
30              10030
40              10040
100             50000
```

### Interface Status
```
Leaf-1# show ip interface brief

Interface            IP Address      Interface Status
Lo0                  10.0.2.1        protocol-up/link-up/admin-up
Eth1/1               10.2.1.1        protocol-up/link-up/admin-up
Eth1/2               10.2.2.1        protocol-up/link-up/admin-up
Eth1/3               10.2.3.1        protocol-up/link-up/admin-up
Eth1/4               10.2.4.1        protocol-up/link-up/admin-up
```

---

## VRF Configuration (Leaf Switches)

```
Leaf-1# show vrf mylab

VRF-Name                           VRF-ID State   Reason
mylab                                   3 Up      --
```

---

## Notes

### BGP Neighbor Status
- BGP neighbors show as **Idle/Active** because physical links are not yet connected in CML topology
- Once physical links are created in CML, BGP will automatically establish
- All configurations are saved to startup-config

### Required CML Topology Links

**Super-Spine to Spine:**
| From | Interface | To | Interface |
|------|-----------|-----|-----------|
| Super-Spine-1 | E1/1 | Spine-1 | E1/5 |
| Super-Spine-1 | E1/2 | Spine-2 | E1/5 |
| Super-Spine-1 | E1/3 | Spine-3 | E1/5 |
| Super-Spine-1 | E1/4 | Spine-4 | E1/5 |
| Super-Spine-2 | E1/1 | Spine-1 | E1/6 |
| Super-Spine-2 | E1/2 | Spine-2 | E1/6 |
| Super-Spine-2 | E1/3 | Spine-3 | E1/6 |
| Super-Spine-2 | E1/4 | Spine-4 | E1/6 |

**Spine to Leaf:**
| From | Interface | To | Interface |
|------|-----------|-----|-----------|
| Spine-1 | E1/1 | Leaf-1 | E1/1 |
| Spine-1 | E1/2 | Leaf-2 | E1/1 |
| Spine-1 | E1/3 | Leaf-3 | E1/1 |
| Spine-1 | E1/4 | Leaf-4 | E1/1 |
| Spine-2 | E1/1 | Leaf-1 | E1/2 |
| Spine-2 | E1/2 | Leaf-2 | E1/2 |
| Spine-2 | E1/3 | Leaf-3 | E1/2 |
| Spine-2 | E1/4 | Leaf-4 | E1/2 |
| Spine-3 | E1/1 | Leaf-1 | E1/3 |
| Spine-3 | E1/2 | Leaf-2 | E1/3 |
| Spine-3 | E1/3 | Leaf-3 | E1/3 |
| Spine-3 | E1/4 | Leaf-4 | E1/3 |
| Spine-4 | E1/1 | Leaf-1 | E1/4 |
| Spine-4 | E1/2 | Leaf-2 | E1/4 |
| Spine-4 | E1/3 | Leaf-3 | E1/4 |
| Spine-4 | E1/4 | Leaf-4 | E1/4 |

### Verification Commands

After connecting physical links, run these commands to verify:

```bash
# Check BGP neighbors
show bgp l2vpn evpn summary

# Check NVE peers (VTEP tunnels)
show nve peers

# Check EVPN routes
show bgp l2vpn evpn

# Check VNI status
show nve vni

# Check VXLAN
show vxlan
```
