#!/bin/bash
# Script 2: FOSS Package Inspector
# Author: [Prateek Pal] | Course: Open Source Software
# Description: Checks if a FOSS package is installed, displays its info,
#              and provides a philosophical note about the software

# --- Variables ---
PACKAGE=""  # Will be set by user input or default value

# --- Display Header ---
echo "========================================"
echo "   FOSS PACKAGE INSPECTOR"
echo "========================================"
echo ""

# --- Get Package Name from User ---
# Check if package name was provided as command-line argument
if [ $# -eq 0 ]; then
    # No argument provided, ask user for input
    echo "Enter the package name to inspect (e.g., apache2, vim, git, firefox):"
    read PACKAGE
else
    # Use the first command-line argument as package name
    PACKAGE=$1
fi

echo ""
echo "Inspecting package: $PACKAGE"
echo "----------------------------------------"

# --- Detect Package Manager ---
# Different Linux distros use different package managers
# We'll check which one is available and use it accordingly

if command -v dpkg &>/dev/null; then
    # Debian/Ubuntu-based systems use dpkg
    PKG_MANAGER="dpkg"
    echo "Detected package manager: dpkg (Debian/Ubuntu-based)"
    echo ""
    
    # Check if package is installed
    if dpkg -l | grep -q "^ii.*$PACKAGE"; then
        echo "✓ $PACKAGE is INSTALLED on this system."
        echo ""
        echo "--- Package Details ---"
        # Display package information
        dpkg -l $PACKAGE 2>/dev/null | grep "^ii" | awk '{print "Status: Installed\nVersion: " $3}'
        
        # Get additional details if available
        if dpkg -s $PACKAGE &>/dev/null; then
            echo ""
            dpkg -s $PACKAGE 2>/dev/null | grep -E "^Version:|^Description:|^Maintainer:" | sed 's/^Description: /Summary: /'
        fi
    else
        echo "✗ $PACKAGE is NOT installed on this system."
        echo ""
        echo "To install it, you can try:"
        echo "  sudo apt update"
        echo "  sudo apt install $PACKAGE"
    fi

elif command -v rpm &>/dev/null; then
    # Red Hat/Fedora/CentOS-based systems use rpm
    PKG_MANAGER="rpm"
    echo "Detected package manager: rpm (Red Hat/Fedora-based)"
    echo ""
    
    # Check if package is installed
    if rpm -q $PACKAGE &>/dev/null; then
        echo "✓ $PACKAGE is INSTALLED on this system."
        echo ""
        echo "--- Package Details ---"
        # Display package information using rpm
        rpm -qi $PACKAGE 2>/dev/null | grep -E "^Name|^Version|^License|^Summary"
    else
        echo "✗ $PACKAGE is NOT installed on this system."
        echo ""
        echo "To install it, you can try:"
        echo "  sudo yum install $PACKAGE"
        echo "  or"
        echo "  sudo dnf install $PACKAGE"
    fi

else
    # Fallback for other systems
    echo "⚠ Could not detect dpkg or rpm package manager."
    echo "Attempting alternative check..."
    echo ""
    
    # Try using 'which' or 'command' to see if the software exists
    if command -v $PACKAGE &>/dev/null; then
        echo "✓ $PACKAGE appears to be available on this system."
        PACKAGE_PATH=$(which $PACKAGE 2>/dev/null)
        echo "Location: $PACKAGE_PATH"
        
        # Try to get version if the program supports --version
        if $PACKAGE --version &>/dev/null; then
            echo "Version info:"
            $PACKAGE --version 2>/dev/null | head -n 1
        fi
    else
        echo "✗ $PACKAGE does not appear to be installed."
    fi
fi

echo ""
echo "========================================"
echo "   FOSS PHILOSOPHY & PURPOSE"
echo "========================================"

# --- Case Statement: Package Philosophy ---
# This section provides insights into what each package does
# and its significance in the open-source world

case $PACKAGE in
    # Web Servers
    httpd|apache|apache2)
        echo "📡 Apache HTTP Server"
        echo "   'The web server that built the open internet'"
        echo "   Powers over 30% of all websites worldwide."
        echo "   License: Apache License 2.0"
        ;;
    
    nginx)
        echo "📡 NGINX"
        echo "   'High-performance web server and reverse proxy'"
        echo "   Known for handling thousands of concurrent connections efficiently."
        echo "   License: BSD-like (2-clause)"
        ;;
    
    # Databases
    mysql|mysql-server)
        echo "🗄️  MySQL"
        echo "   'Open source at the heart of millions of apps'"
        echo "   The world's most popular open-source relational database."
        echo "   License: GPL v2 (Community Edition)"
        ;;
    
    postgresql|postgresql-server)
        echo "🗄️  PostgreSQL"
        echo "   'The world's most advanced open source database'"
        echo "   Known for reliability, robustness, and standards compliance."
        echo "   License: PostgreSQL License (permissive)"
        ;;
    
    mariadb|mariadb-server)
        echo "🗄️  MariaDB"
        echo "   'The open source fork that stayed true to its roots'"
        echo "   A community-driven MySQL alternative ensuring freedom."
        echo "   License: GPL v2"
        ;;
    
    # Version Control
    git)
        echo "🔀 Git"
        echo "   'Distributed version control for the masses'"
        echo "   Created by Linus Torvalds, powers GitHub, GitLab, and collaboration."
        echo "   License: GPL v2"
        ;;
    
    # Text Editors
    vim)
        echo "✏️  Vim"
        echo "   'The ubiquitous text editor for efficiency masters'"
        echo "   Charityware supporting children in Uganda. Highly configurable."
        echo "   License: Vim License (GPL-compatible charityware)"
        ;;
    
    emacs)
        echo "✏️  GNU Emacs"
        echo "   'The extensible, customizable, self-documenting editor'"
        echo "   More than an editor—it's a Lisp-based computing environment."
        echo "   License: GPL v3"
        ;;
    
    nano)
        echo "✏️  GNU nano"
        echo "   'Simple, user-friendly text editor for everyone'"
        echo "   Perfect for beginners and quick edits on the command line."
        echo "   License: GPL v3"
        ;;
    
    # Browsers
    firefox)
        echo "🌐 Mozilla Firefox"
        echo "   'The browser that fights for your privacy'"
        echo "   Community-driven, privacy-focused web browsing."
        echo "   License: Mozilla Public License 2.0"
        ;;
    
    chromium|chromium-browser)
        echo "🌐 Chromium"
        echo "   'The open-source foundation of modern browsing'"
        echo "   The project behind Chrome, without proprietary additions."
        echo "   License: BSD and others (multi-licensed)"
        ;;
    
    # Programming Languages & Tools
    python|python3)
        echo "🐍 Python"
        echo "   'Simplicity and readability for all programmers'"
        echo "   From beginners to AI researchers, Python powers innovation."
        echo "   License: Python Software Foundation License"
        ;;
    
    gcc)
        echo "⚙️  GNU Compiler Collection"
        echo "   'The compiler that compiles the open source world'"
        echo "   Essential toolchain for building C, C++, and more."
        echo "   License: GPL v3"
        ;;
    
    # Media Players
    vlc)
        echo "🎬 VLC Media Player"
        echo "   'Plays everything, asks for nothing'"
        echo "   The Swiss Army knife of media players—no codecs needed."
        echo "   License: GPL v2"
        ;;
    
    # System Tools
    bash)
        echo "💻 GNU Bash"
        echo "   'The shell that speaks to the kernel'"
        echo "   The default command interpreter for most Linux systems."
        echo "   License: GPL v3"
        ;;
    
    openssh|openssh-server)
        echo "🔐 OpenSSH"
        echo "   'Secure communication in an insecure world'"
        echo "   The gold standard for encrypted remote access."
        echo "   License: BSD-style"
        ;;
    
    docker|docker.io)
        echo "🐳 Docker"
        echo "   'Containerization for consistent deployments'"
        echo "   Build, ship, and run applications anywhere with containers."
        echo "   License: Apache License 2.0"
        ;;
    
    # Office & Productivity
    libreoffice)
        echo "📄 LibreOffice"
        echo "   'Freedom in office productivity'"
        echo "   A complete office suite free from vendor lock-in."
        echo "   License: Mozilla Public License 2.0"
        ;;
    
    # Default case for unknown packages
    *)
        echo "📦 $PACKAGE"
        echo "   'Part of the vast open-source ecosystem'"
        echo "   Every package contributes to software freedom."
        echo "   Check the package details above for specific license info."
        ;;
esac

echo ""
echo "========================================"
echo "   End of Package Inspection"
echo "========================================"
echo ""
echo "💡 Tip: Run this script with a package name as argument:"
echo "   ./foss_inspector.sh firefox"
echo ""
