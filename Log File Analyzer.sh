#!/bin/bash
# Script 4: Log File Analyzer
# Author: [Prateek Pal] | Course: Open Source Software
# Description: Analyzes log files for keywords (errors, warnings, etc.),
#              provides statistics, and displays matching lines
# Usage: ./log_analyzer.sh [logfile] [keyword] [options]

# --- Variables ---
LOGFILE=$1
KEYWORD=${2:-"error"}  # Default keyword is 'error' if not provided
CASE_SENSITIVE=${3:-"no"}  # Default to case-insensitive search

# Counters for different severity levels
ERROR_COUNT=0
WARNING_COUNT=0
INFO_COUNT=0
CRITICAL_COUNT=0
KEYWORD_COUNT=0

# Arrays to store matching lines
declare -a MATCHING_LINES
declare -a ERROR_LINES
declare -a WARNING_LINES

# --- Functions ---

# Function to display usage information
show_usage() {
    echo "Usage: $0 [logfile] [keyword] [case-sensitive]"
    echo ""
    echo "Arguments:"
    echo "  logfile        - Path to the log file to analyze (required)"
    echo "  keyword        - Keyword to search for (default: 'error')"
    echo "  case-sensitive - 'yes' for case-sensitive, 'no' for case-insensitive (default: 'no')"
    echo ""
    echo "Examples:"
    echo "  $0 /var/log/syslog"
    echo "  $0 /var/log/syslog warning"
    echo "  $0 /var/log/apache2/error.log 404 yes"
    echo "  $0 sample.log failed no"
    echo ""
    echo "Common log files to analyze:"
    echo "  /var/log/syslog       - System log (Debian/Ubuntu)"
    echo "  /var/log/messages     - System log (Red Hat/CentOS)"
    echo "  /var/log/auth.log     - Authentication log"
    echo "  /var/log/apache2/error.log  - Apache error log"
    echo "  /var/log/nginx/error.log    - NGINX error log"
    echo ""
}

# Function to create a sample log file for testing
create_sample_log() {
    local sample_file="sample_system.log"
    echo "Creating sample log file: $sample_file"
    
    cat > "$sample_file" << 'EOF'
2024-01-15 08:23:45 INFO System startup initiated
2024-01-15 08:23:46 INFO Loading configuration files
2024-01-15 08:23:47 WARNING Configuration file /etc/app/config.ini not found, using defaults
2024-01-15 08:23:50 INFO Service 'webserver' started successfully
2024-01-15 08:24:12 ERROR Failed to connect to database server at 192.168.1.100
2024-01-15 08:24:12 ERROR Connection timeout after 30 seconds
2024-01-15 08:24:15 WARNING Retrying database connection (attempt 1/3)
2024-01-15 08:24:45 ERROR Database connection failed again
2024-01-15 08:24:45 CRITICAL Unable to start application without database
2024-01-15 08:25:00 INFO Administrator notified of critical error
2024-01-15 08:26:30 INFO Database server restored
2024-01-15 08:26:31 INFO Successfully connected to database
2024-01-15 08:26:32 INFO Application started normally
2024-01-15 09:15:22 WARNING High memory usage detected (85%)
2024-01-15 09:15:23 INFO Garbage collection initiated
2024-01-15 10:30:45 ERROR User authentication failed for user 'admin'
2024-01-15 10:30:50 WARNING Multiple failed login attempts from IP 203.0.113.42
2024-01-15 10:31:00 ERROR Possible brute force attack detected
2024-01-15 10:31:01 CRITICAL IP 203.0.113.42 has been blocked
2024-01-15 11:45:00 INFO System health check passed
2024-01-15 12:00:00 INFO Hourly backup completed successfully
2024-01-15 14:30:15 WARNING Disk usage on /var partition at 78%
2024-01-15 14:30:16 INFO Cleanup job scheduled
2024-01-15 15:45:30 ERROR Network timeout while contacting external API
2024-01-15 15:45:35 WARNING Falling back to cached data
2024-01-15 16:20:10 INFO User session expired for user 'jsmith'
2024-01-15 17:00:00 INFO Daily report generated
2024-01-15 18:30:45 ERROR File permission denied: /var/app/data/output.txt
2024-01-15 18:30:46 WARNING Application running with reduced functionality
2024-01-15 19:15:00 INFO System update available
2024-01-15 20:00:00 INFO Nightly maintenance started
EOF
    
    echo "Sample log file created with 30 entries"
    echo "You can now run: $0 $sample_file"
    echo ""
}

# Function to analyze log file and display statistics
analyze_log_statistics() {
    local logfile=$1
    local total_lines=$(wc -l < "$logfile")
    
    echo ""
    echo "📊 LOG FILE STATISTICS"
    echo "   ========================================="
    echo "   Total Lines      : $total_lines"
    echo "   ERROR entries    : $ERROR_COUNT"
    echo "   WARNING entries  : $WARNING_COUNT"
    echo "   CRITICAL entries : $CRITICAL_COUNT"
    echo "   INFO entries     : $INFO_COUNT"
    echo "   Keyword matches  : $KEYWORD_COUNT (searching for '$KEYWORD')"
    
    # Calculate percentages
    if [ $total_lines -gt 0 ]; then
        ERROR_PERCENT=$(awk "BEGIN {printf \"%.2f\", ($ERROR_COUNT/$total_lines)*100}")
        WARNING_PERCENT=$(awk "BEGIN {printf \"%.2f\", ($WARNING_COUNT/$total_lines)*100}")
        echo "   ========================================="
        echo "   Error Rate       : ${ERROR_PERCENT}%"
        echo "   Warning Rate     : ${WARNING_PERCENT}%"
    fi
    echo ""
}

# Function to display the most recent matching lines
display_recent_matches() {
    local keyword=$1
    local logfile=$2
    local count=${3:-5}  # Default to 5 lines
    
    echo "📋 LAST $count LINES CONTAINING '$keyword':"
    echo "   ========================================="
    
    if [ "$CASE_SENSITIVE" = "yes" ]; then
        RECENT=$(grep "$keyword" "$logfile" 2>/dev/null | tail -n "$count")
    else
        RECENT=$(grep -i "$keyword" "$logfile" 2>/dev/null | tail -n "$count")
    fi
    
    if [ -z "$RECENT" ]; then
        echo "   (No matching lines found)"
    else
        echo "$RECENT" | nl -w3 -s'. ' | sed 's/^/   /'
    fi
    echo ""
}

# Function to display timeline of errors
display_error_timeline() {
    echo "⏱️  ERROR TIMELINE (First and Last Occurrence):"
    echo "   ========================================="
    
    if [ $ERROR_COUNT -gt 0 ]; then
        FIRST_ERROR=$(grep -i "error" "$LOGFILE" 2>/dev/null | head -n 1)
        LAST_ERROR=$(grep -i "error" "$LOGFILE" 2>/dev/null | tail -n 1)
        
        echo "   First ERROR: $FIRST_ERROR"
        echo "   Last ERROR : $LAST_ERROR"
    else
        echo "   No errors found in log file"
    fi
    echo ""
}

# --- Header ---
echo "========================================"
echo "   LOG FILE ANALYZER"
echo "========================================"
echo "Analysis Date: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# --- Check for help flag ---
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_usage
    exit 0
fi

# --- Check if create sample flag is used ---
if [ "$1" = "--create-sample" ]; then
    create_sample_log
    exit 0
fi

# --- Validate Arguments ---
if [ -z "$LOGFILE" ]; then
    echo "❌ ERROR: No log file specified!"
    echo ""
    show_usage
    
    # Offer to create a sample log
    echo "Would you like to create a sample log file for testing? (yes/no)"
    read -r response
    
    if [ "$response" = "yes" ] || [ "$response" = "y" ]; then
        create_sample_log
        echo "Now run the script again with: $0 sample_system.log"
    fi
    
    exit 1
fi

# --- Check if File Exists ---
# Retry mechanism if file doesn't exist
RETRY_COUNT=0
MAX_RETRIES=3

while [ ! -f "$LOGFILE" ] && [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    echo "⚠️  WARNING: File '$LOGFILE' not found."
    
    RETRY_COUNT=$((RETRY_COUNT + 1))
    
    if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
        echo "Retry attempt $RETRY_COUNT of $MAX_RETRIES..."
        echo "Please enter the correct path to the log file (or 'quit' to exit):"
        read -r NEW_LOGFILE
        
        if [ "$NEW_LOGFILE" = "quit" ] || [ "$NEW_LOGFILE" = "q" ]; then
            echo "Exiting..."
            exit 1
        fi
        
        LOGFILE=$NEW_LOGFILE
    fi
done

# Final check after retries
if [ ! -f "$LOGFILE" ]; then
    echo "❌ ERROR: File '$LOGFILE' not found after $MAX_RETRIES attempts."
    echo ""
    echo "Suggestions:"
    echo "  1. Check if the file path is correct"
    echo "  2. Verify you have read permissions: ls -l $LOGFILE"
    echo "  3. Try with sudo if it's a system log: sudo $0 $LOGFILE"
    echo "  4. Create a sample log with: $0 --create-sample"
    exit 1
fi

# --- Check if File is Readable ---
if [ ! -r "$LOGFILE" ]; then
    echo "❌ ERROR: File '$LOGFILE' exists but is not readable."
    echo "Try running with sudo: sudo $0 $LOGFILE $KEYWORD"
    exit 1
fi

# --- Check if File is Empty ---
if [ ! -s "$LOGFILE" ]; then
    echo "⚠️  WARNING: File '$LOGFILE' is empty (0 bytes)."
    echo "There is nothing to analyze."
    
    # Offer to wait for data
    echo ""
    echo "Would you like to wait for data to be written to this file? (yes/no)"
    read -r wait_response
    
    if [ "$wait_response" = "yes" ] || [ "$wait_response" = "y" ]; then
        echo "Monitoring $LOGFILE for changes (Ctrl+C to cancel)..."
        echo "Waiting for file to have content..."
        
        # Wait loop - check every 2 seconds
        while [ ! -s "$LOGFILE" ]; do
            sleep 2
            echo -n "."
        done
        
        echo ""
        echo "✓ File now has content. Proceeding with analysis..."
    else
        exit 1
    fi
fi

# --- Display File Information ---
echo "📁 LOG FILE INFORMATION"
echo "   ========================================="
echo "   File Path        : $LOGFILE"
echo "   File Size        : $(du -h "$LOGFILE" | cut -f1)"
echo "   Last Modified    : $(stat -c %y "$LOGFILE" 2>/dev/null || stat -f "%Sm" "$LOGFILE" 2>/dev/null)"
echo "   Search Keyword   : '$KEYWORD'"
echo "   Case Sensitive   : $CASE_SENSITIVE"
echo "   ========================================="
echo ""

# --- Main Analysis Loop ---
echo "🔍 ANALYZING LOG FILE..."
echo ""

LINE_NUMBER=0

# Read file line by line
while IFS= read -r LINE; do
    LINE_NUMBER=$((LINE_NUMBER + 1))
    
    # Check for the specified keyword
    if [ "$CASE_SENSITIVE" = "yes" ]; then
        # Case-sensitive search
        if echo "$LINE" | grep -q "$KEYWORD"; then
            KEYWORD_COUNT=$((KEYWORD_COUNT + 1))
            MATCHING_LINES+=("$LINE")
        fi
    else
        # Case-insensitive search (default)
        if echo "$LINE" | grep -iq "$KEYWORD"; then
            KEYWORD_COUNT=$((KEYWORD_COUNT + 1))
            MATCHING_LINES+=("$LINE")
        fi
    fi
    
    # Count different severity levels (always case-insensitive for these)
    if echo "$LINE" | grep -iq "error"; then
        ERROR_COUNT=$((ERROR_COUNT + 1))
        ERROR_LINES+=("$LINE")
    fi
    
    if echo "$LINE" | grep -iq "warning"; then
        WARNING_COUNT=$((WARNING_COUNT + 1))
        WARNING_LINES+=("$LINE")
    fi
    
    if echo "$LINE" | grep -iq "critical"; then
        CRITICAL_COUNT=$((CRITICAL_COUNT + 1))
    fi
    
    if echo "$LINE" | grep -iq "info"; then
        INFO_COUNT=$((INFO_COUNT + 1))
    fi
    
done < "$LOGFILE"

# --- Display Results ---
echo "✅ ANALYSIS COMPLETE"
echo ""

# Display statistics
analyze_log_statistics "$LOGFILE"

# Display severity level summary
echo "🚦 SEVERITY BREAKDOWN"
echo "   ========================================="
if [ $CRITICAL_COUNT -gt 0 ]; then
    echo "   🔴 CRITICAL : $CRITICAL_COUNT (Immediate attention required!)"
fi
if [ $ERROR_COUNT -gt 0 ]; then
    echo "   🟠 ERROR    : $ERROR_COUNT (Issues need resolution)"
fi
if [ $WARNING_COUNT -gt 0 ]; then
    echo "   🟡 WARNING  : $WARNING_COUNT (Potential issues)"
fi
if [ $INFO_COUNT -gt 0 ]; then
    echo "   🟢 INFO     : $INFO_COUNT (Normal operations)"
fi
echo ""

# Display keyword search results
echo "🔎 KEYWORD SEARCH RESULTS"
echo "   ========================================="
echo "   Searched for : '$KEYWORD'"
echo "   Matches found: $KEYWORD_COUNT"
echo ""

# Display last 5 matching lines for the keyword
if [ $KEYWORD_COUNT -gt 0 ]; then
    display_recent_matches "$KEYWORD" "$LOGFILE" 5
fi

# Display error timeline if errors exist
if [ $ERROR_COUNT -gt 0 ]; then
    display_error_timeline
fi

# --- Additional Analysis ---
echo "📈 ADDITIONAL INSIGHTS"
echo "   ========================================="

# Find most common words in errors (top 5)
if [ $ERROR_COUNT -gt 0 ]; then
    echo "   Most common words in ERROR lines:"
    grep -i "error" "$LOGFILE" 2>/dev/null | \
        tr '[:upper:]' '[:lower:]' | \
        tr -cs '[:alpha:]' '\n' | \
        grep -v "^$" | \
        sort | uniq -c | sort -rn | head -5 | \
        awk '{print "      " $2 " (" $1 " occurrences)"}'
    echo ""
fi

# Time-based analysis (if timestamps exist)
echo "   Time distribution of log entries:"
if grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}|^[A-Z][a-z]{2} +[0-9]' "$LOGFILE"; then
    # Count entries by hour (simplified)
    grep -oE '[0-9]{2}:[0-9]{2}:[0-9]{2}' "$LOGFILE" 2>/dev/null | \
        cut -d':' -f1 | sort | uniq -c | sort -rn | head -3 | \
        awk '{print "      Hour " $2 ":00 - " $1 " entries"}'
else
    echo "      (No standard timestamps detected)"
fi

echo ""

# --- Recommendations ---
echo "💡 RECOMMENDATIONS"
echo "   ========================================="

if [ $CRITICAL_COUNT -gt 0 ]; then
    echo "   ⚠️  URGENT: $CRITICAL_COUNT critical issue(s) found!"
    echo "      Review critical entries immediately"
fi

if [ $ERROR_COUNT -gt 10 ]; then
    echo "   ⚠️  High error count detected ($ERROR_COUNT errors)"
    echo "      Investigate root causes to improve system stability"
elif [ $ERROR_COUNT -gt 0 ]; then
    echo "   ✓ Moderate error count ($ERROR_COUNT errors)"
    echo "      Monitor and address as needed"
else
    echo "   ✓ No errors detected - system appears healthy"
fi

if [ $WARNING_COUNT -gt 20 ]; then
    echo "   ⚠️  Many warnings detected ($WARNING_COUNT)"
    echo "      Review warnings to prevent future errors"
fi

echo ""
echo "   To view all matching lines, use:"
echo "      grep -i '$KEYWORD' $LOGFILE"
echo ""
echo "   To monitor the log in real-time, use:"
echo "      tail -f $LOGFILE"
echo ""

# --- Export Option ---
echo "📤 EXPORT RESULTS"
echo "   ========================================="
echo "   Would you like to export the analysis to a file? (yes/no)"
read -r export_choice

if [ "$export_choice" = "yes" ] || [ "$export_choice" = "y" ]; then
    REPORT_FILE="log_analysis_report_$(date +%Y%m%d_%H%M%S).txt"
    
    {
        echo "LOG FILE ANALYSIS REPORT"
        echo "Generated: $(date)"
        echo "Log File: $LOGFILE"
        echo "Keyword: $KEYWORD"
        echo ""
        echo "STATISTICS:"
        echo "  Total Lines: $(wc -l < "$LOGFILE")"
        echo "  Errors: $ERROR_COUNT"
        echo "  Warnings: $WARNING_COUNT"
        echo "  Critical: $CRITICAL_COUNT"
        echo "  Keyword Matches: $KEYWORD_COUNT"
        echo ""
        echo "MATCHING LINES:"
        grep -i "$KEYWORD" "$LOGFILE" 2>/dev/null
    } > "$REPORT_FILE"
    
    echo "   ✓ Report exported to: $REPORT_FILE"
fi

echo ""

# --- Footer ---
echo "========================================"
echo "   End of Log Analysis"
echo "========================================"
echo ""