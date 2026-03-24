#!/bin/bash
# Script 1: System Identity Report
# Author: [Prateek Pal] | Course: Open Source Software
# Description: Displays system information including distro, kernel, user info, and uptime

# --- Variables ---
STUDENT_NAME="Prateek Pal"  # Fill in your name
SOFTWARE_CHOICE="Python : Image Search Engine"  # Fill in your chosen software

# --- System Information Collection ---
# Get the kernel version
KERNEL=$(uname -r)

# Get the current logged-in username
USER_NAME=$(whoami)

# Get the user's home directory
HOME_DIR=$HOME

# Get system uptime in human-readable format
UPTIME=$(uptime -p)

# Get the current date and time
CURRENT_DATE=$(date "+%A, %B %d, %Y at %I:%M:%S %p")

# Get the Linux distribution name
# This checks multiple sources to ensure compatibility across different distros
if [ -f /etc/os-release ]; then
    # Most modern distros have this file
    DISTRO=$(grep "^PRETTY_NAME" /etc/os-release | cut -d'"' -f2)
elif [ -f /etc/lsb-release ]; then
    # Ubuntu and derivatives
    DISTRO=$(grep "DISTRIB_DESCRIPTION" /etc/lsb-release | cut -d'"' -f2)
else
    # Fallback method
    DISTRO=$(uname -o)
fi

# --- Display System Identity Report ---
echo "========================================"
echo "   OPEN SOURCE SYSTEM IDENTITY REPORT   "
echo "========================================"
echo ""
echo "Student Name    : $STUDENT_NAME"
echo "Software Choice : $SOFTWARE_CHOICE"
echo ""
echo "--- System Information ---"
echo "Distribution    : $DISTRO"
echo "Kernel Version  : $KERNEL"
echo ""
echo "--- User Information ---"
echo "Current User    : $USER_NAME"
echo "Home Directory  : $HOME_DIR"
echo ""
echo "--- System Status ---"
echo "System Uptime   : $UPTIME"
echo "Current Date    : $CURRENT_DATE"
echo ""
echo "--- License Information ---"
echo "This Linux system is distributed under the"
echo "GNU General Public License (GPL) v2."
echo "You have the freedom to run, study, share,"
echo "and modify this software."
echo ""
echo "========================================"
echo "   End of System Identity Report"
echo "========================================"