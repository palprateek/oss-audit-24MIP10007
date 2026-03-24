#!/bin/bash
# Script 5: Open Source Manifesto Generator
# Author: [Prateek Pal] | Course: Open Source Software
# Description: Generates a personalized open source philosophy statement
#              by asking interactive questions and composing a manifesto
# Note: You could create an alias for this script in ~/.bashrc:
#       alias manifesto='/path/to/manifesto_generator.sh'

# --- Variables ---

SCRIPT_VERSION="1.0"

# --- Color Codes (optional, for better visual appeal) ---
# Note: Remove these if your terminal doesn't support colors
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
RED='\033[0;31m'
RESET='\033[0m'

# --- Functions ---

# Function to display animated header
show_header() {
    clear
    echo -e "${BOLD}${CYAN}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║                                                        ║"
    echo "║        OPEN SOURCE MANIFESTO GENERATOR v${SCRIPT_VERSION}        ║"
    echo "║                                                        ║"
    echo "║          'Freedom to Create, Share, and Inspire'      ║"
    echo "║                                                        ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo ""
}

# Function to display inspirational quotes
show_quote() {
    local quotes=(
        "\"Talk is cheap. Show me the code.\" - Linus Torvalds"
        "\"Free as in freedom, not just free beer.\" - Richard Stallman"
        "\"The best way to predict the future is to invent it.\" - Alan Kay"
        "\"Given enough eyeballs, all bugs are shallow.\" - Eric S. Raymond"
        "\"Software is like sex: it's better when it's free.\" - Linus Torvalds"
    )
    
    # Select random quote
    local random_index=$((RANDOM % ${#quotes[@]}))
    echo -e "${ITALIC}${YELLOW}${quotes[$random_index]}${RESET}"
    echo ""
}

# Function to animate text (simple version)
type_text() {
    local text="$1"
    local delay=${2:-0.03}
    
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo ""
}

# Function to validate non-empty input
validate_input() {
    local input="$1"
    local field_name="$2"
    
    while [ -z "$input" ]; do
        echo -e "${RED}⚠️  This field cannot be empty!${RESET}"
        read -p "Please enter $field_name: " input
    done
    
    echo "$input"
}

# --- Main Script ---

# Display header
show_header

# Show inspirational quote
show_quote

echo -e "${BOLD}${GREEN}Welcome to the Open Source Manifesto Generator!${RESET}"
echo ""
echo "This tool will help you create a personalized statement about"
echo "your open source philosophy and values."
echo ""
echo -e "${YELLOW}You will be asked a series of questions. Take your time to reflect.${RESET}"
echo ""

read -p "Press Enter to begin..."
clear

# --- Collect User Information ---
show_header

echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════${RESET}"
echo -e "${BOLD}          PART 1: ABOUT YOU${RESET}"
echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════${RESET}"
echo ""

# Question 0: User's name
read -p "What is your name? " USER_NAME
USER_NAME=$(validate_input "$USER_NAME" "your name")

echo ""
echo -e "${GREEN}Nice to meet you, $USER_NAME!${RESET}"
echo ""
sleep 1

# --- Core Questions ---
clear
show_header

echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════${RESET}"
echo -e "${BOLD}     PART 2: YOUR OPEN SOURCE JOURNEY${RESET}"
echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════${RESET}"
echo ""

# Question 1: Favorite tool
echo -e "${BOLD}Question 1 of 7:${RESET}"
echo "Name one open-source tool you use every day:"
echo -e "${YELLOW}(Examples: Linux, Git, Firefox, Python, VS Code, Apache, etc.)${RESET}"
read -p "Your answer: " TOOL
TOOL=$(validate_input "$TOOL" "an open-source tool")
echo ""

# Question 2: What freedom means
echo -e "${BOLD}Question 2 of 7:${RESET}"
echo "In one word, what does 'freedom' mean to you in the context of software?"
echo -e "${YELLOW}(Examples: Choice, Independence, Transparency, Community, etc.)${RESET}"
read -p "Your answer: " FREEDOM
FREEDOM=$(validate_input "$FREEDOM" "what freedom means to you")
echo ""

# Question 3: What to build and share
echo -e "${BOLD}Question 3 of 7:${RESET}"
echo "Name one thing you would build and share freely with the world:"
echo -e "${YELLOW}(Examples: A website, an app, a library, educational content, etc.)${RESET}"
read -p "Your answer: " BUILD
BUILD=$(validate_input "$BUILD" "what you would build")
echo ""

# Question 4: Why open source matters
echo -e "${BOLD}Question 4 of 7:${RESET}"
echo "Why does open source software matter to you?"
echo -e "${YELLOW}(Examples: Collaboration, Learning, Innovation, Accessibility, etc.)${RESET}"
read -p "Your answer: " WHY_MATTERS
WHY_MATTERS=$(validate_input "$WHY_MATTERS" "why open source matters")
echo ""

# Question 5: Favorite open source value
echo -e "${BOLD}Question 5 of 7:${RESET}"
echo "Which open source value resonates most with you?"
echo -e "${YELLOW}(Examples: Transparency, Community, Meritocracy, Sharing, etc.)${RESET}"
read -p "Your answer: " VALUE
VALUE=$(validate_input "$VALUE" "your favorite value")
echo ""

# Question 6: Open source license preference
echo -e "${BOLD}Question 6 of 7:${RESET}"
echo "Which open source license appeals to you most?"
echo -e "${YELLOW}(Examples: GPL, MIT, Apache, BSD, MPL, etc.)${RESET}"
echo "If unsure, you can say 'GPL' or 'MIT'"
read -p "Your answer: " LICENSE
LICENSE=$(validate_input "$LICENSE" "a license type")
echo ""

# Question 7: Vision for the future
echo -e "${BOLD}Question 7 of 7:${RESET}"
echo "Complete this sentence: 'I believe the future of technology should be...'"
echo -e "${YELLOW}(Examples: 'open and collaborative', 'accessible to all', etc.)${RESET}"
read -p "Your answer: " VISION
VISION=$(validate_input "$VISION" "your vision")
echo ""

# --- Additional Metadata ---
DATE=$(date '+%d %B %Y')
TIME=$(date '+%H:%M:%S')
FULL_DATETIME=$(date '+%A, %d %B %Y at %H:%M:%S %Z')
USERNAME=$(whoami)
HOSTNAME=$(hostname)
KERNEL=$(uname -r)

# --- Generate Output Filename ---
# Create a safe filename from user's name (replace spaces with underscores)
SAFE_NAME=$(echo "$USER_NAME" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
OUTPUT="manifesto_${SAFE_NAME}_$(date '+%Y%m%d').txt"

# Alternative output formats
OUTPUT_HTML="manifesto_${SAFE_NAME}_$(date '+%Y%m%d').html"
OUTPUT_MD="manifesto_${SAFE_NAME}_$(date '+%Y%m%d').md"

# --- Compose the Manifesto ---
clear
show_header

echo -e "${BOLD}${GREEN}✨ Generating your personal Open Source Manifesto...${RESET}"
echo ""

# Simulate processing
for i in {1..3}; do
    echo -n "."
    sleep 0.5
done
echo ""
echo ""

# --- Write to Text File ---
cat > "$OUTPUT" << EOF
╔════════════════════════════════════════════════════════════════════╗
║                                                                    ║
║              MY OPEN SOURCE MANIFESTO                              ║
║                                                                    ║
╚════════════════════════════════════════════════════════════════════╝

Author: $USER_NAME
Date: $FULL_DATETIME
System: $(uname -s) $KERNEL
Generated by: Open Source Manifesto Generator v$SCRIPT_VERSION

════════════════════════════════════════════════════════════════════

                        MY DECLARATION

I, $USER_NAME, declare my commitment to the principles and philosophy
of open source software.

════════════════════════════════════════════════════════════════════

Every day, I rely on $TOOL, a testament to what collaborative 
development can achieve. This tool represents the power of shared 
knowledge and collective innovation.

To me, freedom in software means $FREEDOM. This principle guides my
choices and actions in the digital world. It reminds me that software
should empower users, not restrict them.

I envision a future where I can create and freely share $BUILD with
the global community. By doing so, I hope to contribute to the commons
of human knowledge and help others on their journey.

Open source matters to me because of $WHY_MATTERS. It represents a 
movement that transcends mere code—it's about building a better world
through collaboration and mutual support.

Among the many values of open source, $VALUE resonates most deeply 
with me. This value shapes how I approach both technology and community.

I align myself with the $LICENSE license philosophy, which I believe
best embodies the spirit of software freedom and ensures that my 
contributions remain accessible to all.

════════════════════════════════════════════════════════════════════

                        MY VISION

I believe the future of technology should be $VISION.

════════════════════════════════════════════════════════════════════

                    THE FOUR FREEDOMS I UPHOLD

Following in the footsteps of the Free Software Foundation, I commit
to defending these essential freedoms:

  Freedom 0: The freedom to RUN the program as you wish, for any 
             purpose.

  Freedom 1: The freedom to STUDY how the program works, and change 
             it to make it do what you wish.

  Freedom 2: The freedom to REDISTRIBUTE copies so you can help 
             others.

  Freedom 3: The freedom to DISTRIBUTE copies of your modified 
             versions to others.

════════════════════════════════════════════════════════════════════

                        MY COMMITMENTS

I pledge to:

  ☑ Share knowledge freely and help others learn
  ☑ Contribute to open source projects when possible
  ☑ Respect software licenses and honor creators' wishes
  ☑ Build inclusive and welcoming communities
  ☑ Prioritize accessibility and user empowerment
  ☑ Support sustainable open source development
  ☑ Advocate for software freedom and digital rights

════════════════════════════════════════════════════════════════════

                    INSPIRATIONAL PRINCIPLES

"The best code is the code that is shared."

"Collaboration over competition. Community over corporation."

"Stand on the shoulders of giants, but remember to lift others up."

"Every contribution matters, no matter how small."

"Open source is not just about code—it's about people."

════════════════════════════════════════════════════════════════════

                        ACKNOWLEDGMENTS

I acknowledge and thank:

  • The pioneers of free and open source software: Richard Stallman,
    Linus Torvalds, Eric S. Raymond, and countless others
  
  • The maintainers and contributors who dedicate their time to 
    projects that benefit humanity
  
  • The communities that provide support, guidance, and friendship
  
  • Everyone who chooses openness over secrecy, sharing over hoarding

════════════════════════════════════════════════════════════════════

Signed: $USER_NAME
Date: $DATE

This manifesto represents my personal philosophy and commitment to
the open source movement. It is a living document that will evolve
as I grow in my understanding and practice of these principles.

════════════════════════════════════════════════════════════════════

Generated using Open Source software on a Linux system.
Kernel: $KERNEL | User: $USERNAME@$HOSTNAME

"Free software is a matter of liberty, not price. To understand the
concept, you should think of 'free' as in 'free speech', not as in
'free beer'." — Richard Stallman

════════════════════════════════════════════════════════════════════
EOF

# --- Also create a Markdown version ---
cat > "$OUTPUT_MD" << EOF
# My Open Source Manifesto

**Author:** $USER_NAME  
**Date:** $FULL_DATETIME  
**System:** $(uname -s) $KERNEL  

---

## My Declaration

I, **$USER_NAME**, declare my commitment to the principles and philosophy of open source software.

---

## My Journey

Every day, I rely on **$TOOL**, a testament to what collaborative development can achieve. This tool represents the power of shared knowledge and collective innovation.

To me, freedom in software means **$FREEDOM**. This principle guides my choices and actions in the digital world.

I envision a future where I can create and freely share **$BUILD** with the global community.

---

## Why Open Source Matters

Open source matters to me because of **$WHY_MATTERS**.

Among the many values of open source, **$VALUE** resonates most deeply with me.

I align myself with the **$LICENSE** license philosophy.

---

## My Vision

> I believe the future of technology should be **$VISION**.

---

## The Four Freedoms I Uphold

- **Freedom 0:** The freedom to run the program as you wish
- **Freedom 1:** The freedom to study and modify the program  
- **Freedom 2:** The freedom to redistribute copies
- **Freedom 3:** The freedom to distribute modified versions

---

## My Commitments

- ☑ Share knowledge freely and help others learn
- ☑ Contribute to open source projects when possible
- ☑ Respect software licenses and honor creators' wishes
- ☑ Build inclusive and welcoming communities
- ☑ Prioritize accessibility and user empowerment

---

**Signed:** $USER_NAME  
**Date:** $DATE

---

*Generated using Open Source software*
EOF

# --- Create HTML version (bonus!) ---
cat > "$OUTPUT_HTML" << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Open Source Manifesto - $USER_NAME</title>
    <style>
        body {
            font-family: 'Georgia', serif;
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #333;
        }
        .container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
        }
        h1 {
            color: #667eea;
            text-align: center;
            border-bottom: 3px solid #667eea;
            padding-bottom: 10px;
        }
        h2 {
            color: #764ba2;
            margin-top: 30px;
        }
        .metadata {
            background: #f5f5f5;
            padding: 15px;
            border-left: 4px solid #667eea;
            margin: 20px 0;
            font-size: 0.9em;
        }
        .highlight {
            background: #fff3cd;
            padding: 2px 5px;
            border-radius: 3px;
            font-weight: bold;
        }
        .vision {
            font-size: 1.2em;
            font-style: italic;
            text-align: center;
            color: #667eea;
            margin: 30px 0;
            padding: 20px;
            background: #f8f9ff;
            border-radius: 8px;
        }
        ul {
            line-height: 1.8;
        }
        .signature {
            margin-top: 40px;
            text-align: right;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🌟 My Open Source Manifesto 🌟</h1>
        
        <div class="metadata">
            <strong>Author:</strong> $USER_NAME<br>
            <strong>Date:</strong> $FULL_DATETIME<br>
            <strong>System:</strong> $(uname -s) $KERNEL
        </div>

        <h2>My Declaration</h2>
        <p>I, <strong>$USER_NAME</strong>, declare my commitment to the principles and philosophy of open source software.</p>

        <h2>My Journey</h2>
        <p>Every day, I rely on <span class="highlight">$TOOL</span>, a testament to what collaborative development can achieve.</p>
        <p>To me, freedom in software means <span class="highlight">$FREEDOM</span>.</p>
        <p>I envision a future where I can create and freely share <span class="highlight">$BUILD</span> with the global community.</p>

        <h2>Why Open Source Matters</h2>
        <p>Open source matters to me because of <span class="highlight">$WHY_MATTERS</span>.</p>
        <p>Among the many values of open source, <span class="highlight">$VALUE</span> resonates most deeply with me.</p>
        <p>I align myself with the <span class="highlight">$LICENSE</span> license philosophy.</p>

        <div class="vision">
            "I believe the future of technology should be <strong>$VISION</strong>."
        </div>

        <h2>My Commitments</h2>
        <ul>
            <li>☑ Share knowledge freely and help others learn</li>
            <li>☑ Contribute to open source projects when possible</li>
            <li>☑ Respect software licenses and honor creators' wishes</li>
            <li>☑ Build inclusive and welcoming communities</li>
            <li>☑ Prioritize accessibility and user empowerment</li>
        </ul>

        <div class="signature">
            <strong>Signed:</strong> $USER_NAME<br>
            <strong>Date:</strong> $DATE
        </div>
    </div>
</body>
</html>
EOF

# --- Display Success Message ---
echo -e "${BOLD}${GREEN}✅ SUCCESS! Your manifesto has been generated!${RESET}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════${RESET}"
echo ""
echo "📄 Files created:"
echo "   • $OUTPUT (text version)"
echo "   • $OUTPUT_MD (markdown version)"
echo "   • $OUTPUT_HTML (web version)"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════${RESET}"
echo ""

# --- Display the manifesto ---
echo -e "${BOLD}${YELLOW}Here is your Open Source Manifesto:${RESET}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════${RESET}"
cat "$OUTPUT"
echo -e "${CYAN}═══════════════════════════════════════════════${RESET}"
echo ""

# --- Offer to share ---
echo -e "${BOLD}What would you like to do next?${RESET}"
echo ""
echo "1. View HTML version in browser"
echo "2. Email the manifesto"
echo "3. Display file locations"
echo "4. Exit"
echo ""

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo ""
        echo "Opening HTML version..."
        
        # Try to open in browser
        if command -v xdg-open &>/dev/null; then
            xdg-open "$OUTPUT_HTML"
        elif command -v open &>/dev/null; then
            open "$OUTPUT_HTML"
        else
            echo "Could not auto-open browser. Please open this file manually:"
            echo "  $OUTPUT_HTML"
        fi
        ;;
    2)
        echo ""
        read -p "Enter email address: " email
        if [ -n "$email" ]; then
            echo "To email your manifesto, use:"
            echo "  mail -s 'My Open Source Manifesto' $email < $OUTPUT"
            echo ""
            echo "(Make sure 'mail' command is installed)"
        fi
        ;;
    3)
        echo ""
        echo "Full file paths:"
        echo "  Text: $(pwd)/$OUTPUT"
        echo "  Markdown: $(pwd)/$OUTPUT_MD"
        echo "  HTML: $(pwd)/$OUTPUT_HTML"
        ;;
    4)
        echo ""
        echo "Thank you for creating your manifesto!"
        ;;
    *)
        echo "Invalid choice. Exiting."
        ;;
esac

echo ""
echo -e "${BOLD}${GREEN}═══════════════════════════════════════════════${RESET}"
echo -e "${BOLD}${GREEN}  Thank you for participating in the open     ${RESET}"
echo -e "${BOLD}${GREEN}  source movement, $USER_NAME!                ${RESET}"
echo -e "${BOLD}${GREEN}═══════════════════════════════════════════════${RESET}"
echo ""

# --- Suggest creating an alias ---
echo -e "${YELLOW}💡 TIP: Create an alias to run this anytime!${RESET}"
echo ""
echo "Add this line to your ~/.bashrc or ~/.bash_aliases:"
echo ""
echo -e "${CYAN}alias manifesto='$(pwd)/$0'${RESET}"
echo ""
echo "Then you can simply type 'manifesto' to run this script!"
echo ""

# --- End of Script ---
exit 0
