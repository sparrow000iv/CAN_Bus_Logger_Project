#!/bin/bash

# GitHub Setup Script for CAN Bus Logger Project
# This script helps you set up and push the project to GitHub

set -e  # Exit on error

echo "=== GitHub Setup Script - CAN Bus Logger ==="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}→ $1${NC}"
}

print_header() {
    echo -e "${BLUE}$1${NC}"
}

# Check if git is installed
check_git() {
    if ! command -v git &> /dev/null; then
        print_error "Git not found"
        print_info "Installing git..."
        sudo apt-get update
        sudo apt-get install -y git
    fi
    print_success "Git is available"
}

# Get user information
get_user_info() {
    print_header "Step 1: User Information"
    echo ""
    
    read -p "Enter your GitHub username: " GITHUB_USERNAME
    read -p "Enter your email: " USER_EMAIL
    read -p "Enter your name: " USER_NAME
    
    echo ""
    print_info "Username: $GITHUB_USERNAME"
    print_info "Email: $USER_EMAIL"
    print_info "Name: $USER_NAME"
    echo ""
}

# Initialize git repository
init_git() {
    print_header "Step 2: Initialize Git Repository"
    echo ""
    
    # Check if already initialized
    if [ -d ".git" ]; then
        print_info "Git repository already initialized"
    else
        git init
        print_success "Git repository initialized"
    fi
    
    # Configure git user
    git config user.email "$USER_EMAIL"
    git config user.name "$USER_NAME"
    print_success "Git user configured"
}

# Create GitHub repository
create_github_repo() {
    print_header "Step 3: Create GitHub Repository"
    echo ""
    
    print_info "You need to create a repository on GitHub"
    echo ""
    echo "Please follow these steps:"
    echo "1. Go to https://github.com/new"
    echo "2. Repository name: can-bus-logger"
    echo "3. Description: CAN bus data logger using SocketCAN for automotive communication"
    echo "4. Select Public or Private"
    echo "5. DO NOT initialize with README, .gitignore, or license"
    echo "6. Click 'Create repository'"
    echo ""
    
    read -p "Press Enter after creating the repository on GitHub..."
    echo ""
}

# Add files to git
add_files() {
    print_header "Step 4: Add Files to Git"
    echo ""
    
    # Add all files
    git add .
    print_success "Files added to git"
    
    # Show status
    echo ""
    print_info "Files to be committed:"
    git status
    echo ""
}

# Commit changes
commit_changes() {
    print_header "Step 5: Commit Changes"
    echo ""
    
    git commit -m "Initial commit: CAN Bus Communication Logger using SocketCAN

Features:
- CAN bus data logger using SocketCAN API
- Send and capture CAN frames
- Virtual CAN (vcan) interface support
- CAN frame parsing and analysis
- Data logging with timestamps
- CSV export functionality
- Python-based CAN parser and analyzer

Author: $USER_NAME"
    
    print_success "Changes committed"
}

# Push to GitHub
push_to_github() {
    print_header "Step 6: Push to GitHub"
    echo ""
    
    # Add remote
    git remote add origin "https://github.com/$GITHUB_USERNAME/can-bus-logger.git"
    print_success "Remote added"
    
    # Push to GitHub
    print_info "Pushing to GitHub..."
    git push -u origin main
    
    print_success "Successfully pushed to GitHub!"
    echo ""
    print_info "Your repository is now available at:"
    echo "https://github.com/$GITHUB_USERNAME/can-bus-logger"
}

# Show next steps
show_next_steps() {
    print_header "🎉 Setup Complete!"
    echo ""
    echo "Your CAN Bus Logger project is now on GitHub!"
    echo ""
    echo "Next steps:"
    echo "1. Visit your repository: https://github.com/$GITHUB_USERNAME/can-bus-logger"
    echo "2. Add a description and topics in repository settings"
    echo "3. Star your own repository ⭐"
    echo "4. Share with others!"
    echo ""
    echo "To clone this repository:"
    echo "git clone https://github.com/$GITHUB_USERNAME/can-bus-logger.git"
    echo ""
    echo "To use:"
    echo "cd can-bus-logger"
    echo "make all"
    echo "make setup_vcan"
    echo "make test"
    echo ""
}

# Main script
main() {
    check_git
    get_user_info
    init_git
    create_github_repo
    add_files
    commit_changes
    push_to_github
    show_next_steps
}

main
