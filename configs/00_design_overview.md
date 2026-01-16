# BGP EVPN VXLAN Design Overview

## Topology Summary

```
                    ┌─────────────────────────────────────┐
                    │         SUPER-SPINE LAYER           │
                    │   Super-Spine-1    Super-Spine-2    │
                    │    AS 65000          AS 65000       │
                    │   Lo0: 10.0.0.1    Lo0: 10.0.0.2    │
                    └─────────────────────────────────────┘
                              │  │  │  │
                    ┌─────────────────────────────────────┐
                    │           SPINE LAYER               │
                    │ Spine-1  Spine-2  Spine-3  Spine-4  │
                    │ AS 65001 AS 65002 AS 65003 AS 65004 │
                    │ 10.0.1.1 10.0.1.2 10.0.1.3 10.0.1.4 │
                    └─────────────────────────────────────┘
                              │  │  │  │
                    ┌─────────────────────────────────────┐
                    │           LEAF LAYER (VTEPs)        │
                    │  Leaf-1   Leaf-2   Leaf-3   Leaf-4  │
                    │ AS 65101 AS 65102 AS 65103 AS 65104 │
                    │ 10.0.2.1 10.0.2.2 10.0.2.3 10.0.2.4 │
                    │    VTEP     VTEP     VTEP     VTEP  │
                    └─────────────────────────────────────┘
```

## BGP ASN Assignment (Cisco DC Design)

| Device | BGP ASN | Role | Loopback0 |
|--------|---------|------|-----------|
| Super-Spine-1 | 65000 | Route Reflector | 10.0.0.1/32 |
| Super-Spine-2 | 65000 | Route Reflector | 10.0.0.2/32 |
| Spine-1 | 65001 | Spine/Transit | 10.0.1.1/32 |
| Spine-2 | 65002 | Spine/Transit | 10.0.1.2/32 |
| Spine-3 | 65003 | Spine/Transit | 10.0.1.3/32 |
| Spine-4 | 65004 | Spine/Transit | 10.0.1.4/32 |
| Leaf-1 | 65101 | VTEP | 10.0.2.1/32 |
| Leaf-2 | 65102 | VTEP | 10.0.2.2/32 |
| Leaf-3 | 65103 | VTEP | 10.0.2.3/32 |
| Leaf-4 | 65104 | VTEP | 10.0.2.4/32 |

## Interface Connections

### Super-Spine-1
| Interface | Connects To | IP Address |
|-----------|-------------|------------|
| E1/1 | Spine-1 E1/5 | 10.1.1.0/31 |
| E1/2 | Spine-2 E1/5 | 10.1.1.2/31 |
| E1/3 | Spine-3 E1/5 | 10.1.1.4/31 |
| E1/4 | Spine-4 E1/5 | 10.1.1.6/31 |

### Super-Spine-2
| Interface | Connects To | IP Address |
|-----------|-------------|------------|
| E1/1 | Spine-1 E1/6 | 10.1.2.0/31 |
| E1/2 | Spine-2 E1/6 | 10.1.2.2/31 |
| E1/3 | Spine-3 E1/6 | 10.1.2.4/31 |
| E1/4 | Spine-4 E1/6 | 10.1.2.6/31 |

### Spine-1
| Interface | Connects To | IP Address |
|-----------|-------------|------------|
| E1/5 | Super-Spine-1 E1/1 | 10.1.1.1/31 |
| E1/6 | Super-Spine-2 E1/1 | 10.1.2.1/31 |
| E1/1 | Leaf-1 E1/1 | 10.2.1.0/31 |
| E1/2 | Leaf-2 E1/1 | 10.2.1.2/31 |
| E1/3 | Leaf-3 E1/1 | 10.2.1.4/31 |
| E1/4 | Leaf-4 E1/1 | 10.2.1.6/31 |

### Spine-2
| Interface | Connects To | IP Address |
|-----------|-------------|------------|
| E1/5 | Super-Spine-1 E1/2 | 10.1.1.3/31 |
| E1/6 | Super-Spine-2 E1/2 | 10.1.2.3/31 |
| E1/1 | Leaf-1 E1/2 | 10.2.2.0/31 |
| E1/2 | Leaf-2 E1/2 | 10.2.2.2/31 |
| E1/3 | Leaf-3 E1/2 | 10.2.2.4/31 |
| E1/4 | Leaf-4 E1/2 | 10.2.2.6/31 |

### Spine-3
| Interface | Connects To | IP Address |
|-----------|-------------|------------|
| E1/5 | Super-Spine-1 E1/3 | 10.1.1.5/31 |
| E1/6 | Super-Spine-2 E1/3 | 10.1.2.5/31 |
| E1/1 | Leaf-1 E1/3 | 10.2.3.0/31 |
| E1/2 | Leaf-2 E1/3 | 10.2.3.2/31 |
| E1/3 | Leaf-3 E1/3 | 10.2.3.4/31 |
| E1/4 | Leaf-4 E1/3 | 10.2.3.6/31 |

### Spine-4
| Interface | Connects To | IP Address |
|-----------|-------------|------------|
| E1/5 | Super-Spine-1 E1/4 | 10.1.1.7/31 |
| E1/6 | Super-Spine-2 E1/4 | 10.1.2.7/31 |
| E1/1 | Leaf-1 E1/4 | 10.2.4.0/31 |
| E1/2 | Leaf-2 E1/4 | 10.2.4.2/31 |
| E1/3 | Leaf-3 E1/4 | 10.2.4.4/31 |
| E1/4 | Leaf-4 E1/4 | 10.2.4.6/31 |

### Leaf Interfaces (to Spines)
| Leaf | E1/1 (Spine-1) | E1/2 (Spine-2) | E1/3 (Spine-3) | E1/4 (Spine-4) |
|------|----------------|----------------|----------------|----------------|
| Leaf-1 | 10.2.1.1/31 | 10.2.2.1/31 | 10.2.3.1/31 | 10.2.4.1/31 |
| Leaf-2 | 10.2.1.3/31 | 10.2.2.3/31 | 10.2.3.3/31 | 10.2.4.3/31 |
| Leaf-3 | 10.2.1.5/31 | 10.2.2.5/31 | 10.2.3.5/31 | 10.2.4.5/31 |
| Leaf-4 | 10.2.1.7/31 | 10.2.2.7/31 | 10.2.3.7/31 | 10.2.4.7/31 |

## VXLAN / EVPN Design

### VRF Configuration
- **VRF Name:** mylab
- **VNI (L3VNI):** 50000
- **Route-Target:** 65000:50000

### VLAN to VNI Mapping
| VLAN | VNI | Anycast Gateway | Description |
|------|-----|-----------------|-------------|
| 10 | 10010 | 192.168.10.1/24 | VLAN 10 |
| 20 | 10020 | 192.168.20.1/24 | VLAN 20 |
| 30 | 10030 | 192.168.30.1/24 | VLAN 30 |
| 40 | 10040 | 192.168.40.1/24 | VLAN 40 |

### Anycast Gateway
- **Virtual MAC:** 0000.1111.2222
- Configured on all Leaf switches (VTEPs)
- Same IP and MAC across all leaves for seamless VM mobility

## BGP Design

### Underlay (IPv4)
- eBGP between all layers
- Advertise loopback addresses for VTEP reachability

### Overlay (EVPN)
- eBGP EVPN address-family
- Route-Type 2: MAC/IP advertisement
- Route-Type 5: IP Prefix (for L3VNI)
