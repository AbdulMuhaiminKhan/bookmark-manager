# Git Commit - Visual Step-by-Step

## 🎬 Video Script (If You Want to Record)

Imagine this workflow:

```
START
  ↓
[Open PowerShell/Terminal]
  ↓
[Navigate to project folder]
  ↓
[git status] - See what changed
  ↓
[git add .] - Stage all changes
  ↓
[git commit -m "message"] - Save changes
  ↓
[git log] - Verify commit
  ↓
[git push origin main] - Upload to GitHub
  ↓
END
```

---

## 📸 Step-by-Step with Screenshots

### Step 1: Open PowerShell

**On Windows:**
- Right-click in folder → "Open PowerShell window here"
- OR Press: `Win + X` → PowerShell

---

### Step 2: Check Git is Ready

**Type:**
```
git --version
```

**You should see:**
```
git version 2.40.0.windows.1
```

If not → Download from https://git-scm.com/download/win

---

### Step 3: Configure Git (First Time Only)

**Type:**
```
git config --global user.name "Your Name"
```

Then:
```
git config --global user.email "your.email@example.com"
```

**Example:**
```
git config --global user.name "John Doe"
git config --global user.email "john.doe@gmail.com"
```

---

### Step 4: Navigate to Project

**Type:**
```
cd "C:\personal development\bookmark-manager"
```

**Verify you're in right folder:**
```
pwd
```

You should see:
```
C:\personal development\bookmark-manager
```

---

### Step 5: Check What Changed

**Type:**
```
git status
```

**You'll see:**
```
On branch main

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        .env
        .env.example
        .gitignore
        .github/workflows/ci-cd.yml
        Dockerfile
        Dockerfile.prod
        IMPROVEMENTS.md
        QUICK_REFERENCE.md
        README.md
        THINK3DDD_ANALYSIS.md
        backup.sh
        bookmarks/
        ... more files
```

This shows all the new files you created.

---

### Step 6: Stage All Files

**Type:**
```
git add .
```

The `.` means "all files in current folder".

---

### Step 7: Verify Files are Staged

**Type:**
```
git status
```

You should see:
```
On branch main

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   .env
        new file:   .env.example
        new file:   .gitignore
        new file:   .github/workflows/ci-cd.yml
        new file:   Dockerfile
        ... (many more files)

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        media/
        staticfiles/
```

Files under "Changes to be committed" are staged ✅

---

### Step 8: Create Commit

**Type:**
```
git commit -m "Add production infrastructure: K8s, CI/CD, backups, health checks, monitoring"
```

**You'll see:**
```
[main (root-commit) a1b2c3d] Add production infrastructure: K8s, CI/CD, backups, health checks, monitoring
 25 files changed, 5000 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 .github/workflows/ci-cd.yml
 ... (list of all changes)
```

✅ Commit created!

---

### Step 9: Verify Commit

**Type:**
```
git log
```

**You'll see:**
```
commit a1b2c3d1234567890abcdef (HEAD -> main)
Author: John Doe <john.doe@gmail.com>
Date:   Fri Apr 19 13:00:00 2026 +0000

    Add production infrastructure: K8s, CI/CD, backups, health checks, monitoring
```

✅ Commit verified!

---

### Step 10: Push to GitHub

**First Time - Connect to Remote:**

```
git remote add origin https://github.com/yourusername/bookmark-manager.git
```

Replace `yourusername` with your actual GitHub username.

**Then Push:**

```
git push -u origin main
```

**You'll see:**
```
Enumerating objects: 25, done.
Counting objects: 100% (25/25), done.
Delta compression using up to 8 threads
Compressing objects: 100% (20/20), done.
Writing objects: 100% (25/25), 50 KiB | 5.0 MiB/s, done.
Total 25 (delta 0), reused 0 (delta 0), reused pack 0
To https://github.com/yourusername/bookmark-manager.git
 * [new branch]      main -> main
 * Branch 'main' is set to track remote branch 'main' from 'origin'.
```

✅ Pushed to GitHub!

---

## 🎯 Quick Copy-Paste Commands

### Copy this entire block and paste into PowerShell:

```powershell
# Step 1: Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Step 2: Navigate to project
cd "C:\personal development\bookmark-manager"

# Step 3: Check status
git status

# Step 4: Stage all files
git add .

# Step 5: Create commit
git commit -m "Add production infrastructure: K8s, CI/CD, backups, health checks, monitoring"

# Step 6: Verify
git log

# Step 7: Connect to GitHub (first time only)
git remote add origin https://github.com/yourusername/bookmark-manager.git

# Step 8: Push to GitHub
git push -u origin main
```

**Replace:**
- `Your Name` with your name
- `your.email@example.com` with your email
- `yourusername` with your GitHub username

---

## 📱 Real Example

**Complete workflow with actual commands:**

```powershell
PS C:\Users\John> cd "C:\personal development\bookmark-manager"
PS C:\personal development\bookmark-manager> git config --global user.name "John Doe"
PS C:\personal development\bookmark-manager> git config --global user.email "john@example.com"
PS C:\personal development\bookmark-manager> git status

On branch main
No commits yet

Untracked files:
  .gitignore
  README.md
  Dockerfile.prod
  ... (more files)

PS C:\personal development\bookmark-manager> git add .
PS C:\personal development\bookmark-manager> git status

On branch main
No commits yet

Changes to be committed:
  new file:   .gitignore
  new file:   README.md
  ... (more files)

PS C:\personal development\bookmark-manager> git commit -m "Add production infrastructure"
[main (root-commit) a1b2c3d] Add production infrastructure
 25 files changed, 5000 insertions(+)

PS C:\personal development\bookmark-manager> git log
commit a1b2c3d (HEAD -> main)
Author: John Doe <john@example.com>
Date:   Fri Apr 19 2026

    Add production infrastructure

PS C:\personal development\bookmark-manager> git remote add origin https://github.com/johndoe/bookmark-manager.git
PS C:\personal development\bookmark-manager> git push -u origin main
Enumerating objects: 25, done.
Total 25 (delta 0), reused 0 (delta 0)
To https://github.com/johndoe/bookmark-manager.git
 * [new branch]      main -> main

PS C:\personal development\bookmark-manager>
```

---

## ✅ What You Should See After

### In PowerShell:
```
✅ Commit created
✅ Files uploaded to GitHub
```

### On GitHub Website:
1. Go to https://github.com/yourusername/bookmark-manager
2. You should see:
   - All your files listed
   - `.gitignore` file
   - `README.md` file
   - `Dockerfile.prod` file
   - All other new files
3. Click "Commits" → See your commit message

---

## 🚨 If Something Goes Wrong

### "git command not found"
→ Download Git: https://git-scm.com/download/win

### "fatal: not a git repository"
→ Run `git init` first

### "Please configure your user"
→ Run:
```
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### "fatal: The current branch has no upstream"
→ Run:
```
git push -u origin main
```

### "authentication failed"
→ If using 2FA: Use Personal Access Token from https://github.com/settings/tokens

---

## 🎉 Success Indicators

- ✅ No error messages
- ✅ See "X files changed, Y insertions"
- ✅ `git log` shows your commit
- ✅ Files appear on GitHub.com

---

## Next Time (Easier)

After first commit, next time is just:

```powershell
cd "C:\personal development\bookmark-manager"
git add .
git commit -m "Your message here"
git push origin main
```

That's it! 3 commands instead of 8.

---

**You've got this! 🚀**
