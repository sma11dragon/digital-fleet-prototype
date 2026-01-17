#!/bin/bash

# Digital Fleet Prototype - Auto Deploy Script
# This script automates pushing changes to GitHub Pages

# Color codes for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Project directory
PROJECT_DIR="/Users/siewloongchan/Documents/DAE - Operations/Countries/Malaysia/Digital Fleet/digital-fleet-prototype"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Digital Fleet Prototype Deployment${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Navigate to project directory
echo -e "${YELLOW}→ Navigating to project directory...${NC}"
cd "$PROJECT_DIR" || {
    echo -e "${RED}✗ Error: Could not navigate to project directory${NC}"
    exit 1
}
echo -e "${GREEN}✓ Current directory: $(pwd)${NC}\n"

# Check if this is a git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}✗ Error: This is not a git repository${NC}"
    echo -e "${YELLOW}  Run 'git init' first or check your directory${NC}"
    exit 1
fi

# Check git status
echo -e "${YELLOW}→ Checking for changes...${NC}"
if git diff-index --quiet HEAD --; then
    echo -e "${GREEN}✓ No changes detected - repository is up to date${NC}"
    echo -e "${BLUE}  Your website is already synchronized!${NC}"
    exit 0
fi

# Show what will be committed
echo -e "${YELLOW}→ Files to be committed:${NC}"
git status --short
echo ""

# Add all changes
echo -e "${YELLOW}→ Staging all changes...${NC}"
git add .
echo -e "${GREEN}✓ Changes staged${NC}\n"

# Create commit message with timestamp
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
COMMIT_MSG="Update: $TIMESTAMP - Auto-deploy from local"

echo -e "${YELLOW}→ Creating commit...${NC}"
git commit -m "$COMMIT_MSG"
echo -e "${GREEN}✓ Commit created${NC}\n"

# Push to GitHub
echo -e "${YELLOW}→ Pushing to GitHub (main branch)...${NC}"
git push origin main || git push origin master || {
    echo -e "${RED}✗ Error: Failed to push to GitHub${NC}"
    echo -e "${YELLOW}  Please check:${NC}"
    echo -e "${YELLOW}  - Your internet connection${NC}"
    echo -e "${YELLOW}  - GitHub authentication (token or SSH key)${NC}"
    echo -e "${YELLOW}  - Branch name (main or master)${NC}"
    exit 1
}

echo -e "${GREEN}✓ Successfully pushed to GitHub!${NC}\n"

# GitHub Pages info
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ Deployment Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Your changes are now live at:${NC}"
echo -e "${GREEN}https://digitalfleet.daeit.com.sg${NC}"
echo -e "${YELLOW}Note: GitHub Pages may take 1-2 minutes to update${NC}\n"
