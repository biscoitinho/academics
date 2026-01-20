# Version Control (Git)

## Git Basics

```bash
# Initialize repository
git init

# Clone repository
git clone https://github.com/user/repo.git

# Check status
git status

# Add files
git add file.txt
git add .  # Add all

# Commit
git commit -m "Add feature"

# View history
git log
git log --oneline
git log --graph --oneline --all

# View changes
git diff  # Unstaged changes
git diff --staged  # Staged changes
git diff HEAD~1  # Compare with previous commit
```

## Configuration

```bash
# Set name and email
git config --global user.name "John Doe"
git config --global user.email "john@example.com"

# Set default editor
git config --global core.editor "vim"

# View config
git config --list

# Set default branch name
git config --global init.defaultBranch main
```

## Staging and Committing

```bash
# Stage specific files
git add file1.txt file2.txt

# Stage all changes
git add .

# Stage interactively
git add -p  # Review each change

# Unstage file
git reset file.txt

# Commit with message
git commit -m "Fix bug"

# Commit all tracked changes
git commit -am "Update files"

# Amend last commit
git commit --amend -m "New message"

# Add to last commit (no message change)
git add forgotten_file.txt
git commit --amend --no-edit
```

## Branching

```bash
# List branches
git branch
git branch -a  # Include remote

# Create branch
git branch feature-login

# Switch branch
git checkout feature-login
# Or (Git 2.23+)
git switch feature-login

# Create and switch
git checkout -b feature-login
# Or
git switch -c feature-login

# Delete branch
git branch -d feature-login  # Safe delete
git branch -D feature-login  # Force delete

# Rename branch
git branch -m old-name new-name
```

## Merging

```bash
# Merge feature into main
git checkout main
git merge feature-login

# Fast-forward merge (default if possible)
# main moved forward to feature-login

# No fast-forward (creates merge commit)
git merge --no-ff feature-login

# Merge conflict
# Edit conflicting files
git add resolved_file.txt
git commit

# Abort merge
git merge --abort
```

## Rebasing

```bash
# Rebase feature onto main
git checkout feature-login
git rebase main

# Interactive rebase (edit history)
git rebase -i HEAD~3

# Options:
# pick - keep commit
# reword - change message
# edit - amend commit
# squash - combine with previous
# drop - remove commit

# Continue after resolving conflicts
git rebase --continue

# Abort rebase
git rebase --abort
```

## Merge vs Rebase

```
Merge:
  main:    A---B---C---D (merge commit)
                     /
  feature:      E---F

Rebase:
  main:    A---B---C
                     \
  feature:            E'---F' (commits moved)

Merge: Preserves history, creates merge commits
Rebase: Clean linear history, rewrites commits
```

## Remote Repositories

```bash
# View remotes
git remote -v

# Add remote
git remote add origin https://github.com/user/repo.git

# Fetch changes
git fetch origin

# Pull changes (fetch + merge)
git pull origin main

# Push changes
git push origin main

# Push new branch
git push -u origin feature-login

# Delete remote branch
git push origin --delete feature-login

# Set upstream
git branch --set-upstream-to=origin/main main
```

## Undoing Changes

```bash
# Discard unstaged changes
git checkout -- file.txt
# Or (Git 2.23+)
git restore file.txt

# Unstage file
git reset HEAD file.txt
# Or
git restore --staged file.txt

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Revert commit (create new commit)
git revert abc123

# Reset to specific commit
git reset --hard abc123
```

## Stashing

```bash
# Stash changes
git stash

# Stash with message
git stash save "Work in progress"

# List stashes
git stash list

# Apply stash
git stash apply  # Keep stash
git stash pop    # Apply and remove

# Apply specific stash
git stash apply stash@{0}

# Drop stash
git stash drop stash@{0}

# Clear all stashes
git stash clear
```

## Tags

```bash
# List tags
git tag

# Create lightweight tag
git tag v1.0.0

# Create annotated tag
git tag -a v1.0.0 -m "Version 1.0.0"

# Tag specific commit
git tag v1.0.0 abc123

# Push tags
git push origin v1.0.0
git push origin --tags  # All tags

# Delete tag
git tag -d v1.0.0
git push origin --delete v1.0.0
```

## Viewing History

```bash
# Log
git log
git log --oneline
git log --graph
git log --author="John"
git log --since="2024-01-01"
git log --grep="bug"

# Show commit
git show abc123

# Show file history
git log -- file.txt

# Blame (who changed each line)
git blame file.txt

# Search commits
git log -S"function_name"  # Find when added/removed
```

## Gitignore

```bash
# .gitignore file

# Ignore files
*.log
*.tmp
.env

# Ignore directories
node_modules/
dist/
__pycache__/

# Ignore except
!important.log

# Already tracked file (remove from git)
git rm --cached file.txt
```

## Branching Strategies

### Git Flow

```
Branches:
  main     - Production
  develop  - Development
  feature/* - Features
  release/* - Releases
  hotfix/*  - Urgent fixes

Flow:
1. Create feature branch from develop
2. Merge feature to develop
3. Create release branch from develop
4. Merge release to main and develop
5. Tag release on main
```

### GitHub Flow

```
Branches:
  main      - Always deployable
  feature/* - Short-lived

Flow:
1. Create feature branch from main
2. Open pull request
3. Review and test
4. Merge to main
5. Deploy
```

### Trunk-Based

```
Branches:
  main - Single long-lived branch
  feature/* - Very short-lived (<1 day)

Flow:
1. Small frequent commits to main
2. Feature flags for incomplete features
3. Continuous integration
```

## Pull Requests (GitHub)

```bash
# 1. Create branch
git checkout -b feature-login

# 2. Make changes and commit
git add .
git commit -m "Add login feature"

# 3. Push branch
git push -u origin feature-login

# 4. Create PR on GitHub

# 5. Review and merge

# 6. Delete branch
git checkout main
git pull
git branch -d feature-login
```

## Cherry-Pick

```bash
# Apply specific commit to current branch
git cherry-pick abc123

# Cherry-pick without committing
git cherry-pick --no-commit abc123

# Cherry-pick range
git cherry-pick abc123..def456
```

## Submodules

```bash
# Add submodule
git submodule add https://github.com/user/lib.git lib

# Clone with submodules
git clone --recurse-submodules https://github.com/user/repo.git

# Update submodules
git submodule update --init --recursive

# Pull submodule updates
git submodule update --remote
```

## Bisect (Find Bug)

```bash
# Start bisect
git bisect start

# Mark current as bad
git bisect bad

# Mark old commit as good
git bisect good abc123

# Git checks out middle commit
# Test and mark
git bisect good  # or bad

# Repeat until found
# Reset
git bisect reset
```

## Reflog

```bash
# View all actions (even reset/rebase)
git reflog

# Recover lost commit
git checkout abc123

# Recover deleted branch
git checkout -b recovered-branch abc123
```

## Aliases

```bash
# Create alias
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.lg 'log --oneline --graph --all'

# Use alias
git co main
git st
```

## Hooks

```bash
# Located in .git/hooks/

# Pre-commit hook (.git/hooks/pre-commit)
#!/bin/sh
# Run tests before commit
npm test
if [ $? -ne 0 ]; then
    echo "Tests failed, commit aborted"
    exit 1
fi

# Make executable
chmod +x .git/hooks/pre-commit

# Common hooks:
# pre-commit - Before commit
# commit-msg - Validate commit message
# pre-push - Before push
# post-merge - After merge
```

## Best Practices

```bash
# 1. Commit often
# Small, focused commits

# 2. Write good commit messages
# Subject: Imperative, 50 chars
# Body: Explain why, wrap at 72 chars

# Example:
git commit -m "Add user authentication

Implement JWT-based authentication for API endpoints.
This allows users to securely access protected resources."

# 3. Don't commit secrets
# Use .gitignore for .env, credentials

# 4. Pull before push
git pull origin main
git push origin main

# 5. Use branches
# Don't work directly on main

# 6. Review before committing
git diff
git status

# 7. Keep commits atomic
# One logical change per commit

# 8. Use meaningful branch names
# feature/add-login
# bugfix/fix-auth
# hotfix/critical-bug
```

## Common Workflows

### Feature Development

```bash
# 1. Create feature branch
git checkout -b feature/user-profile

# 2. Work and commit
git add .
git commit -m "Add user profile page"

# 3. Push branch
git push -u origin feature/user-profile

# 4. Open pull request

# 5. After approval, merge
git checkout main
git pull
git merge feature/user-profile

# 6. Push and delete branch
git push
git branch -d feature/user-profile
git push origin --delete feature/user-profile
```

### Fixing Merge Conflicts

```bash
# Conflict occurs during merge
git merge feature-branch
# CONFLICT in file.txt

# 1. View conflicts
git status

# 2. Edit file.txt
<<<<<<< HEAD
Current branch code
=======
Incoming branch code
>>>>>>> feature-branch

# 3. Resolve (choose one or combine)
# Remove markers and keep desired code

# 4. Stage and commit
git add file.txt
git commit
```

## Git Commands Cheatsheet

```bash
# Setup
git init
git clone <url>
git config

# Changes
git status
git diff
git add
git commit

# Branching
git branch
git checkout
git merge
git rebase

# Remote
git remote
git fetch
git pull
git push

# Undo
git reset
git revert
git restore
git stash

# History
git log
git show
git blame

# Tags
git tag
```

## Advanced: Interactive Rebase

```bash
# Clean up last 3 commits
git rebase -i HEAD~3

# Editor opens:
pick abc123 Add feature
pick def456 Fix typo
pick ghi789 Update docs

# Change to:
pick abc123 Add feature
squash def456 Fix typo
squash ghi789 Update docs

# Save and close
# Edit combined commit message
# Result: 1 clean commit instead of 3
```

## Git LFS (Large Files)

```bash
# Install Git LFS
git lfs install

# Track large files
git lfs track "*.psd"
git lfs track "*.zip"

# Commit .gitattributes
git add .gitattributes

# Use normally
git add large_file.psd
git commit -m "Add design file"
git push
```

## Troubleshooting

```bash
# Detached HEAD
# You're not on a branch
git checkout main  # Return to branch

# Forgot to pull before commit
git pull --rebase origin main

# Accidentally committed to wrong branch
git reset HEAD~1  # Undo commit
git stash  # Save changes
git checkout correct-branch
git stash pop

# Remove file from git but keep locally
git rm --cached file.txt

# Undo pushed commits
git revert HEAD  # Safe (creates new commit)
# Or force push (dangerous)
git reset HEAD~1
git push --force

# Large repository
git clone --depth 1 <url>  # Shallow clone
```

## Commit Message Conventions

```
Types:
  feat: New feature
  fix: Bug fix
  docs: Documentation
  style: Formatting
  refactor: Code restructuring
  test: Adding tests
  chore: Maintenance

Format:
  <type>(<scope>): <subject>

  <body>

  <footer>

Example:
  feat(auth): add JWT authentication

  Implement JWT-based authentication for API.
  Users can now login and receive tokens.

  Closes #123
```
