#!/bin/bash

# Quick Deploy with Custom Message
# Usage: ./quick-deploy.sh "Your commit message"

PROJECT_DIR="/Users/siewloongchan/Documents/DAE - Operations/Countries/Malaysia/Digital Fleet/digital-fleet-prototype"

cd "$PROJECT_DIR" || exit 1

# Use provided message or default
if [ -z "$1" ]; then
    MESSAGE="Update: $(date '+%Y-%m-%d %H:%M:%S')"
else
    MESSAGE="$1"
fi

echo "🚀 Deploying Digital Fleet Prototype..."
echo "📝 Commit message: $MESSAGE"
echo ""

git add .
git commit -m "$MESSAGE"
git push origin main || git push origin master

echo ""
echo "✅ Deployed! Check: https://digitalfleet.daeit.com.sg"
echo "⏳ GitHub Pages may take 1-2 minutes to update"
