#!/bin/bash
# Script 3: Disk and Permission Auditor
# Author: [Prateek Pal] | Course: Open Source Software
# Description: Audits important system directories for disk usage and permissions,
#              and checks configuration directories for installed FOSS software

# --- Directory Lists ---
# System directories to audit
SYSTEM_DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/opt" "/usr/share" "/root")

# Common FOSS software configuration directories
# Add your chosen software's config directory here
SOFTWARE_DIRS=(
    "/etc/apache2"           # Apache on Debian/Ubuntu
    "/etc/httpd"             # Apache on Red Hat/Fedora
    "/etc/nginx"             # NGINX web server
    "/etc/mysql"             # MySQL database
    "/etc/postgresql"        # PostgreSQL database
    "/etc/ssh"               # OpenSSH
    "/etc/docker"            # Docker
    "/etc/git"               # Git
    "/usr/share/vim"         # Vim editor
    "/etc/firefox"           # Firefox browser
)

# --- Functions ---

# Function to get filesystem usage for a directory
get_filesystem_usage() {
    local dir=$1
    # Use df to get filesystem usage (percentage and mount point)
    df -h "$dir" 2>/dev/null | awk 'NR==2 {print $5 " used on " $6}'
}

# Function to check if user has read permissions
check_access() {
    local dir=$1
    if [ -r "$dir" ]; then
        echo "✓ Readable"
    else
        echo "✗ Not Readable (need sudo)"
    fi
}

# --- Header ---
echo "========================================"
echo "   DISK AND PERMISSION AUDITOR"
echo "========================================"
echo "Audit Date: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# --- Part 1: System Directory Audit ---
echo "========================================"
echo "   SYSTEM DIRECTORY AUDIT"
echo "========================================"
echo ""

# Loop through each system directory
for DIR in "${SYSTEM_DIRS[@]}"; do
    echo "📁 Checking: $DIR"
    echo "   ----------------------------------------"
    
    # Check if directory exists
    if [ -d "$DIR" ]; then
        # Get permissions, owner, and group using ls -ld
        PERMS=$(ls -ld "$DIR" 2>/dev/null | awk '{print $1}')
        OWNER=$(ls -ld "$DIR" 2>/dev/null | awk '{print $3}')
        GROUP=$(ls -ld "$DIR" 2>/dev/null | awk '{print $4}')
        
        # Get directory size using du (disk usage)
        echo -n "   Calculating size... "
        SIZE=$(du -sh "$DIR" 2>/dev/null | cut -f1)
        
        # If du fails (permission denied), show message
        if [ -z "$SIZE" ]; then
            SIZE="Permission Denied"
        fi
        echo "Done"
        
        # Get filesystem usage
        FS_USAGE=$(get_filesystem_usage "$DIR")
        
        # Get number of files/subdirectories (if accessible)
        if [ -r "$DIR" ]; then
            FILE_COUNT=$(find "$DIR" -maxdepth 1 2>/dev/null | wc -l)
            FILE_COUNT=$((FILE_COUNT - 1))  # Subtract 1 for the directory itself
        else
            FILE_COUNT="N/A"
        fi
        
        # Display the information
        echo "   Status       : ✓ EXISTS"
        echo "   Permissions  : $PERMS"
        echo "   Owner        : $OWNER"
        echo "   Group        : $GROUP"
        echo "   Directory Size: $SIZE"
        echo "   Filesystem   : $FS_USAGE"
        echo "   Items (depth 1): $FILE_COUNT"
        echo "   Access       : $(check_access "$DIR")"
        
        # Explain permission string
        echo "   Permission Breakdown:"
        echo "     Type: ${PERMS:0:1} (d=directory, l=link, -=file)"
        echo "     Owner: ${PERMS:1:3} (read/write/execute for owner)"
        echo "     Group: ${PERMS:4:3} (read/write/execute for group)"
        echo "     Others: ${PERMS:7:3} (read/write/execute for others)"
        
    else
        echo "   Status       : ✗ DOES NOT EXIST"
        echo "   This directory is not present on this system."
    fi
    
    echo ""
done

# --- Part 2: FOSS Software Configuration Directory Audit ---
echo "========================================"
echo "   FOSS SOFTWARE CONFIG AUDIT"
echo "========================================"
echo "Checking configuration directories for popular FOSS applications..."
echo ""

# Counter for found directories
FOUND_COUNT=0

# Loop through software configuration directories
for SOFT_DIR in "${SOFTWARE_DIRS[@]}"; do
    # Only process if directory exists
    if [ -d "$SOFT_DIR" ]; then
        FOUND_COUNT=$((FOUND_COUNT + 1))
        
        echo "📂 Found: $SOFT_DIR"
        echo "   ----------------------------------------"
        
        # Get permissions and ownership
        PERMS=$(ls -ld "$SOFT_DIR" 2>/dev/null | awk '{print $1}')
        OWNER=$(ls -ld "$SOFT_DIR" 2>/dev/null | awk '{print $3}')
        GROUP=$(ls -ld "$SOFT_DIR" 2>/dev/null | awk '{print $4}')
        
        # Get size
        SIZE=$(du -sh "$SOFT_DIR" 2>/dev/null | cut -f1)
        if [ -z "$SIZE" ]; then
            SIZE="Permission Denied"
        fi
        
        # Count configuration files
        if [ -r "$SOFT_DIR" ]; then
            CONF_COUNT=$(find "$SOFT_DIR" -type f 2>/dev/null | wc -l)
        else
            CONF_COUNT="N/A"
        fi
        
        # Identify the software
        case $SOFT_DIR in
            *apache2*|*httpd*)
                SOFTWARE_NAME="Apache HTTP Server"
                ;;
            *nginx*)
                SOFTWARE_NAME="NGINX Web Server"
                ;;
            *mysql*)
                SOFTWARE_NAME="MySQL Database"
                ;;
            *postgresql*)
                SOFTWARE_NAME="PostgreSQL Database"
                ;;
            *ssh*)
                SOFTWARE_NAME="OpenSSH"
                ;;
            *docker*)
                SOFTWARE_NAME="Docker"
                ;;
            *git*)
                SOFTWARE_NAME="Git Version Control"
                ;;
            *vim*)
                SOFTWARE_NAME="Vim Text Editor"
                ;;
            *firefox*)
                SOFTWARE_NAME="Firefox Browser"
                ;;
            *)
                SOFTWARE_NAME="Unknown"
                ;;
        esac
        
        echo "   Software     : $SOFTWARE_NAME"
        echo "   Permissions  : $PERMS"
        echo "   Owner:Group  : $OWNER:$GROUP"
        echo "   Config Size  : $SIZE"
        echo "   Config Files : $CONF_COUNT"
        echo "   Access       : $(check_access "$SOFT_DIR")"
        
        # Security check for configuration directories
        echo "   Security Check:"
        
        # Check if world-writable (dangerous!)
        if [[ "$PERMS" == *"w"* ]] && [[ "${PERMS:8:1}" == "w" ]]; then
            echo "     ⚠️  WARNING: Directory is world-writable!"
        else
            echo "     ✓ Directory is not world-writable"
        fi
        
        # Check if owned by root (typical for system configs)
        if [[ "$OWNER" == "root" ]]; then
            echo "     ✓ Owned by root (secure)"
        else
            echo "     ℹ️  Owned by $OWNER (not root)"
        fi
        
        echo ""
    fi
done

# Summary of software configs found
echo "----------------------------------------"
echo "Summary: Found $FOUND_COUNT FOSS software configuration directories"
echo ""

# --- Part 3: Disk Space Summary ---
echo "========================================"
echo "   OVERALL DISK SPACE SUMMARY"
echo "========================================"
echo ""

# Display filesystem usage for all mounted filesystems
echo "Mounted Filesystems:"
df -h | grep -v "tmpfs\|udev\|loop" | awk 'NR==1 {print "   " $0}
                                            NR>1 {print "   " $0}'

echo ""

# Find largest directories in common locations (requires sudo for complete results)
echo "Top 5 Largest Directories in /var (may require sudo for full accuracy):"
du -sh /var/* 2>/dev/null | sort -rh | head -5 | awk '{print "   " $0}'

echo ""
echo "Top 5 Largest Directories in /usr (may require sudo for full accuracy):"
du -sh /usr/* 2>/dev/null | sort -rh | head -5 | awk '{print "   " $0}'

echo ""

# --- Part 4: Permission Security Analysis ---
echo "========================================"
echo "   PERMISSION SECURITY ANALYSIS"
echo "========================================"
echo ""

echo "Checking for potential security issues..."
echo ""

# Check for world-writable directories in critical paths
echo "🔍 Checking for world-writable directories (security risk):"
WORLD_WRITABLE=$(find /etc /var /usr/bin -type d -perm -002 2>/dev/null | head -5)

if [ -z "$WORLD_WRITABLE" ]; then
    echo "   ✓ No world-writable directories found in critical paths"
else
    echo "   ⚠️  WARNING: Found world-writable directories:"
    echo "$WORLD_WRITABLE" | awk '{print "      " $0}'
    echo "   These should be reviewed for security concerns!"
fi

echo ""

# Check for files with SUID/SGID bits in /usr/bin
echo "🔍 Checking SUID/SGID executables in /usr/bin (first 5):"
SUID_FILES=$(find /usr/bin -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null | head -5)

if [ -z "$SUID_FILES" ]; then
    echo "   ℹ️  No SUID/SGID files found"
else
    echo "$SUID_FILES" | while read file; do
        PERMS=$(ls -l "$file" | awk '{print $1}')
        echo "   $file [$PERMS]"
    done
    echo "   (SUID/SGID files run with elevated privileges - normal for system tools)"
fi

echo ""

# --- Part 5: Recommendations ---
echo "========================================"
echo "   RECOMMENDATIONS"
echo "========================================"
echo ""

echo "📋 Audit Recommendations:"
echo "   1. Regularly monitor disk usage to prevent full filesystems"
echo "   2. Review permissions on configuration directories"
echo "   3. Ensure sensitive configs are not world-readable"
echo "   4. Keep FOSS software updated for security patches"
echo "   5. Back up configuration directories regularly"
echo ""
echo "💡 To get more detailed information, run with sudo:"
echo "   sudo ./disk_permission_auditor.sh"
echo ""

# --- Footer ---
echo "========================================"
echo "   End of Audit Report"
echo "========================================"
echo "Generated on: $(date)"
echo ""
