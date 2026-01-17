# Digital Fleet Prototype - Auto-Deploy Setup Guide

## 📋 Overview
These scripts automate the process of pushing your local changes to GitHub Pages, keeping your website synchronized with your local files.

---

## 🔧 One-Time Setup

### Step 1: Copy Scripts to Your Project
1. Save both `deploy-to-github.sh` and `quick-deploy.sh` to your project folder:
   ```
   /Users/siewloongchan/Documents/DAE - Operations/Countries/Malaysia/Digital Fleet/digital-fleet-prototype/
   ```

### Step 2: Make Scripts Executable
Open Terminal and run:
```bash
cd "/Users/siewloongchan/Documents/DAE - Operations/Countries/Malaysia/Digital Fleet/digital-fleet-prototype"
chmod +x deploy-to-github.sh
chmod +x quick-deploy.sh
```

### Step 3: Verify Git Setup
Make sure your repository is connected to GitHub:
```bash
git remote -v
```

You should see:
```
origin  https://github.com/sma11dragon/digital-fleet-prototype.git (fetch)
origin  https://github.com/sma11dragon/digital-fleet-prototype.git (push)
```

If not set up, run:
```bash
git remote add origin https://github.com/sma11dragon/digital-fleet-prototype.git
```

---

## 🚀 How to Use

### Option 1: Full Deploy Script (Recommended for beginners)
This shows detailed progress and checks:

```bash
cd "/Users/siewloongchan/Documents/DAE - Operations/Countries/Malaysia/Digital Fleet/digital-fleet-prototype"
./deploy-to-github.sh
```

**What it does:**
- ✅ Shows which files changed
- ✅ Creates commit with timestamp
- ✅ Pushes to GitHub
- ✅ Displays success message with URL
- ✅ Handles errors gracefully

---

### Option 2: Quick Deploy (For experienced users)
Fast deployment with custom messages:

```bash
cd "/Users/siewloongchan/Documents/DAE - Operations/Countries/Malaysia/Digital Fleet/digital-fleet-prototype"
./quick-deploy.sh "Updated homepage design"
```

Or without a message (uses timestamp):
```bash
./quick-deploy.sh
```

---

## 🎯 Create a Desktop Shortcut (Optional)

### For Maximum Convenience:
Create an alias in your `~/.zshrc` or `~/.bash_profile`:

```bash
# Open your profile
nano ~/.zshrc

# Add this line:
alias deploy-fleet='cd "/Users/siewloongchan/Documents/DAE - Operations/Countries/Malaysia/Digital Fleet/digital-fleet-prototype" && ./deploy-to-github.sh'

# Save and reload
source ~/.zshrc
```

Now you can deploy from anywhere by just typing:
```bash
deploy-fleet
```

---

## 🔍 Troubleshooting

### Error: "Permission denied"
**Solution:** Make scripts executable
```bash
chmod +x deploy-to-github.sh quick-deploy.sh
```

### Error: "Could not navigate to project directory"
**Solution:** Check the path in the script matches your actual project location

### Error: "Failed to push to GitHub"
**Possible causes:**
1. **Not authenticated** - Set up GitHub authentication:
   - Personal Access Token: https://github.com/settings/tokens
   - Or SSH key: https://github.com/settings/keys

2. **Wrong branch name** - Check your default branch:
   ```bash
   git branch
   ```
   If it's `master` instead of `main`, the script will try both.

3. **No internet connection** - Check your network

### Error: "This is not a git repository"
**Solution:** Initialize git in your project:
```bash
cd "/Users/siewloongchan/Documents/DAE - Operations/Countries/Malaysia/Digital Fleet/digital-fleet-prototype"
git init
git remote add origin https://github.com/sma11dragon/digital-fleet-prototype.git
```

---

## 📝 Workflow Example

**Daily development workflow:**

1. Edit your files in VS Code or any editor
2. Save changes
3. Open Terminal
4. Run: `./deploy-to-github.sh`
5. Wait 1-2 minutes
6. Check: https://digitalfleet.daeit.com.sg

---

## ⚡ Pro Tips

1. **Before deploying:** Test locally by opening `index.html` in browser
2. **Check status anytime:** `git status`
3. **View commit history:** `git log --oneline`
4. **Undo last commit (if not pushed):** `git reset --soft HEAD~1`
5. **Force refresh website:** Hold Shift + Click Refresh in browser

---

## 🔐 GitHub Authentication Setup

If you haven't set up authentication:

### Option A: Personal Access Token (Recommended)
1. Go to: https://github.com/settings/tokens
2. Generate new token (classic)
3. Select scopes: `repo` (all)
4. Copy the token
5. When pushing, use token as password

### Option B: SSH Key
1. Generate key: `ssh-keygen -t ed25519 -C "your-email@example.com"`
2. Add to GitHub: https://github.com/settings/keys
3. Update remote: 
   ```bash
   git remote set-url origin git@github.com:sma11dragon/digital-fleet-prototype.git
   ```

---

## 📞 Need Help?

If something doesn't work:
1. Check the error message carefully
2. Verify all paths are correct
3. Ensure git is installed: `git --version`
4. Check GitHub repository exists and you have access

---

**Happy Deploying! 🚀**
