# MobaXterm Session Setup Guide

This guide explains how to add CML lab device sessions to MobaXterm, either manually or by editing the configuration file directly.

## Method 1: Manual Setup (GUI)

1. Open MobaXterm
2. Right-click in the **Sessions** sidebar
3. Select **New session**
4. Choose **SSH** as session type
5. Configure:
   - **Remote host:** Device IP (e.g., `192.168.30.110`)
   - **Username:** `admin`
   - **Port:** `22`
6. Click **OK**
7. Optionally drag the session into a folder

### Creating Folders
1. Right-click in Sessions sidebar
2. Select **New folder**
3. Name it (e.g., "CML_Lab" or "SuperSpine")

## Method 2: INI File Editing (Bulk)

For adding many sessions at once, edit the MobaXterm configuration file directly.

### Step 1: Locate the INI File

| Installation Type | Location |
|------------------|----------|
| **Installed** | `%APPDATA%\MobaXterm\MobaXterm.ini` |
| **Portable** | `<MobaXterm folder>\MobaXterm.ini` |

### Step 2: Close MobaXterm

> **IMPORTANT:** MobaXterm must be completely closed before editing the INI file. Otherwise, your changes will be overwritten.

### Step 3: Edit the INI File

Find the last `[Bookmarks_N]` section and add a new one with the next number.

#### Example: Adding a "CML_Lab" Folder with Sessions

```ini
[Bookmarks_99]
SubRep=CML_Lab
ImgNum=41
Super-Spine-1=#109#0%192.168.30.118%22%admin%%-1%-1%%%%%0%0%0%%%-1%-1%0%0%%1080%%0%0%1%%0%%%%0%-1%-1%0%%#MobaFont%10%0%0%-1%15%236,236,236%30,30,30%180,180,192%0%-1%0%%xterm%-1%0%_Std_Colors_0_%80%24%0%3%-1%<none>%%0%0%-1%0%#0# #-1
Super-Spine-2=#109#0%192.168.30.119%22%admin%%-1%-1%%%%%0%0%0%%%-1%-1%0%0%%1080%%0%0%1%%0%%%%0%-1%-1%0%%#MobaFont%10%0%0%-1%15%236,236,236%30,30,30%180,180,192%0%-1%0%%xterm%-1%0%_Std_Colors_0_%80%24%0%3%-1%<none>%%0%0%-1%0%#0# #-1
Spine-1=#109#0%192.168.30.110%22%admin%%-1%-1%%%%%0%0%0%%%-1%-1%0%0%%1080%%0%0%1%%0%%%%0%-1%-1%0%%#MobaFont%10%0%0%-1%15%236,236,236%30,30,30%180,180,192%0%-1%0%%xterm%-1%0%_Std_Colors_0_%80%24%0%3%-1%<none>%%0%0%-1%0%#0# #-1
Spine-2=#109#0%192.168.30.111%22%admin%%-1%-1%%%%%0%0%0%%%-1%-1%0%0%%1080%%0%0%1%%0%%%%0%-1%-1%0%%#MobaFont%10%0%0%-1%15%236,236,236%30,30,30%180,180,192%0%-1%0%%xterm%-1%0%_Std_Colors_0_%80%24%0%3%-1%<none>%%0%0%-1%0%#0# #-1
Spine-3=#109#0%192.168.30.112%22%admin%%-1%-1%%%%%0%0%0%%%-1%-1%0%0%%1080%%0%0%1%%0%%%%0%-1%-1%0%%#MobaFont%10%0%0%-1%15%236,236,236%30,30,30%180,180,192%0%-1%0%%xterm%-1%0%_Std_Colors_0_%80%24%0%3%-1%<none>%%0%0%-1%0%#0# #-1
Spine-4=#109#0%192.168.30.113%22%admin%%-1%-1%%%%%0%0%0%%%-1%-1%0%0%%1080%%0%0%1%%0%%%%0%-1%-1%0%%#MobaFont%10%0%0%-1%15%236,236,236%30,30,30%180,180,192%0%-1%0%%xterm%-1%0%_Std_Colors_0_%80%24%0%3%-1%<none>%%0%0%-1%0%#0# #-1
Leaf-1=#109#0%192.168.30.114%22%admin%%-1%-1%%%%%0%0%0%%%-1%-1%0%0%%1080%%0%0%1%%0%%%%0%-1%-1%0%%#MobaFont%10%0%0%-1%15%236,236,236%30,30,30%180,180,192%0%-1%0%%xterm%-1%0%_Std_Colors_0_%80%24%0%3%-1%<none>%%0%0%-1%0%#0# #-1
Leaf-2=#109#0%192.168.30.115%22%admin%%-1%-1%%%%%0%0%0%%%-1%-1%0%0%%1080%%0%0%1%%0%%%%0%-1%-1%0%%#MobaFont%10%0%0%-1%15%236,236,236%30,30,30%180,180,192%0%-1%0%%xterm%-1%0%_Std_Colors_0_%80%24%0%3%-1%<none>%%0%0%-1%0%#0# #-1
Leaf-3=#109#0%192.168.30.116%22%admin%%-1%-1%%%%%0%0%0%%%-1%-1%0%0%%1080%%0%0%1%%0%%%%0%-1%-1%0%%#MobaFont%10%0%0%-1%15%236,236,236%30,30,30%180,180,192%0%-1%0%%xterm%-1%0%_Std_Colors_0_%80%24%0%3%-1%<none>%%0%0%-1%0%#0# #-1
Leaf-4=#109#0%192.168.30.117%22%admin%%-1%-1%%%%%0%0%0%%%-1%-1%0%0%%1080%%0%0%1%%0%%%%0%-1%-1%0%%#MobaFont%10%0%0%-1%15%236,236,236%30,30,30%180,180,192%0%-1%0%%xterm%-1%0%_Std_Colors_0_%80%24%0%3%-1%<none>%%0%0%-1%0%#0# #-1
```

### Step 4: Reopen MobaXterm

Your new sessions should appear in the sidebar.

## INI Format Reference

### Section Header
```ini
[Bookmarks_N]     # N = unique number (check existing sections)
SubRep=FolderName # Folder name in sidebar
ImgNum=41         # Icon number (41 = folder icon)
```

### Session Entry Format
```
SessionName=#109#0%IP_ADDRESS%22%USERNAME%%...
```

| Field | Value | Description |
|-------|-------|-------------|
| `#109` | SSH type | Connection type (109 = SSH) |
| `IP_ADDRESS` | e.g., 192.168.30.110 | Target host |
| `22` | Port number | SSH port |
| `USERNAME` | e.g., admin | Login username |

### Nested Folders
Use backslash for subfolders:
```ini
SubRep=ParentFolder\ChildFolder
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Sessions don't appear | Close MobaXterm completely, then edit INI |
| Duplicate section numbers | Check existing `[Bookmarks_N]` and use unique number |
| Sessions in wrong folder | Verify `SubRep=` value matches desired folder |
| Icon looks wrong | Change `ImgNum=` value (41=folder, 109=SSH icon) |

## Quick Session Template

Copy and modify this template for new SSH sessions:

```ini
SessionName=#109#0%IP_ADDRESS%22%USERNAME%%-1%-1%%%%%0%0%0%%%-1%-1%0%0%%1080%%0%0%1%%0%%%%0%-1%-1%0%%#MobaFont%10%0%0%-1%15%236,236,236%30,30,30%180,180,192%0%-1%0%%xterm%-1%0%_Std_Colors_0_%80%24%0%3%-1%<none>%%0%0%-1%0%#0# #-1
```

Replace:
- `SessionName` - Display name
- `IP_ADDRESS` - Target IP
- `USERNAME` - SSH username
