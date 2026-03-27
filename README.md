###  **Open Source Software Audit Scripts:** *A collection of 5 Bash scripts for system auditing, package inspection, log analysis, and philosophical reflection.*

**Author:** Prateek Pal  
**Roll Number:** 24MIP10007  
**Chosen Software:** Git (Version Control)  
> *“GPL v3: The tool Linus built when proprietary failed him.”*

---

##  Repository Structure

```
.
├── system_identity.sh     # System Identity Report
├── package_inspector.sh   # FOSS Package Inspector
├── disk_auditor.sh        # Disk & Permission Auditor
├── log_analyzer.sh        # Log File Analyzer
├── manifesto_generator.sh # Open Source Manifesto Generator
└── README.md
```

---

##  **Dependencies** All scripts require a **Linux system** with standard GNU core utilities. No additional packages needed.

| Script          | Required Commands                                                                  | Notes                                                                 |
|-----------------|----------------------------------------------------------------------------------|-----------------------------------------------------------------------|
| **All Scripts** | `bash`, `date`, `whoami`, `hostname`, `uname`                                    | Pre-installed on all Linux systems                                   |
| Script 1        | `uname`, `uptime`, `lsb_release` (or `/etc/os-release`)                          | Works on any modern distro                                           |
| Script 2        | `rpm` **or** `dpkg`, `grep`                                                      | Uses RPM (Fedora/CentOS) or DPKG (Debian/Ubuntu)                     |
| Script 3        | `du`, `ls`, `df`, `find`, `stat`                                                 | May need `sudo` for full access                                      |
| Script 4        | `grep`, `tail`, `wc`, `nl`                                                       | Requires read access to log files (use `sudo` if needed)              |
| Script 5        | None (pure Bash)                                                                 | Creates `.txt`, `.md`, and `.html` files                               |

---

##  **Installation & Setup**

1. **Clone the repository:**
   ```bash
   git clone https://github.com/palprateek/oss-audit-24MIP10007.git
   cd oss-audit-24MIP10007
   ```

2. **Make scripts executable:**
   ```bash
   chmod +x *.sh
   ```

---

##  **Script Descriptions & Usage**

---

### **Script 1: System Identity Report** *Introduces the Linux system like a welcome screen.*

#### **What it shows:**
- Linux distribution name & kernel version
- Current user & home directory
- System uptime & current date/time
- **Student Identity:** Prateek Pal (24MIP10007)
- **Software Choice:** Git (GPL v3)

#### **Run:**
```bash
./system_identity.sh
```

#### **Sample Output:**
```
========================================
    OPEN SOURCE SYSTEM IDENTITY REPORT   
========================================

Student Name    : Prateek Pal
Roll Number     : 24MIP10007
Software Choice : Git (Version Control)

--- System Information ---
Distribution    : Ubuntu 22.04.4 LTS
Kernel Version  : 5.15.0-106-generic

--- User Information ---
Current User    : prat
Home Directory  : /home/prat

--- System Status ---
System Uptime   : up 2 hours 15 minutes
Current Date    : Tuesday, 24 March 2026

--- License Information ---
This Linux system is distributed under the
GNU General Public License (GPL).
```

---

### **Script 2: FOSS Package Inspector** *Checks if a software package is installed and describes its purpose.*

#### **Features:**
- Detects `dpkg` (Debian) or `rpm` (Red Hat) package managers
- Shows version, license, and summary
- Prints a philosophical note based on the package (especially for Git)

#### **Run:**
```bash
./package_inspector.sh git
```

#### **Sample Output (for `git`):**
```
========================================
    FOSS PACKAGE INSPECTOR
========================================

Inspecting package: git
----------------------------------------

Detected package manager: dpkg (Debian/Ubuntu-based)

✓ git is INSTALLED on this system.

--- Package Details ---
Version: 2.34.1

--- Philosophy & Purpose ---
Version Control by Linus Torvalds.
Built out of necessity when proprietary solutions failed 
the Linux kernel community. 
License: GNU General Public License v2.0
```

---

### **Script 3: Disk and Permission Auditor** *Audits system directories for disk usage and permissions.*

#### **Run:**
```bash
sudo ./disk_auditor.sh
```

---

### **Script 4: Log File Analyzer** *Searches logs for keywords (e.g., `ERROR`, `WARNING`) and summarizes findings.*

#### **Run:**
```bash
# Basic usage:
./log_analyzer.sh /var/log/syslog
```

---

### **Script 5: Open Source Manifesto Generator** *Generates a personalized open-source philosophy statement.*

#### **Run:**
```bash
./manifesto_generator.sh
```

#### **Sample Excerpt:**
```
Project by: Prateek Pal (24MIP10007)
I champion Git because it was born from the need for 
independence from proprietary restrictions.
```

---

##  **Quick Start Guide**

```bash
# 1. Clone and make executable
git clone https://github.com/palprateek/oss-audit-24MIP10007.git
cd oss-audit-24MIP10007
chmod +x *.sh

# 2. Run Identity Report
./system_identity.sh
```

---

##  **License** This project is licensed under the **GNU GPL v3**.  
See the [GNU GPL v3 License](https://www.gnu.org/licenses/gpl-3.0.en.html) for details.

---

**Made by Prateek Pal (24MIP10007)** *Inspired by the principles of software freedom and the resilience of Git.*   
