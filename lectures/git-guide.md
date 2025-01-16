# Introduction to Git: A Cross-Platform Julia Guide

## Setting Up Your Development Environment

### Installing Julia

#### Windows
1. Visit [https://julialang.org/downloads/](https://julialang.org/downloads/)
2. Download the Windows .exe installer
3. Run the installer
4. The default path will be something like: `C:\Users\YourUsername\AppData\Local\Programs\Julia-1.9.3\bin`

#### macOS/Linux
1. Visit [https://julialang.org/downloads/](https://julialang.org/downloads/)
2. For macOS: Download and drag the Julia app to Applications
3. For Linux: Download the appropriate tarball for your architecture
   ```bash
   # Linux installation example
   tar zxvf julia-1.9.3-linux-x86_64.tar.gz
   sudo ln -s ~/julia-1.9.3/bin/julia /usr/local/bin/julia
   ```

### Installing VS Code

#### All Platforms
1. Download VS Code from [https://code.visualstudio.com/](https://code.visualstudio.com/)
2. Install the downloaded file
3. Install the Julia extension:
   - Open VS Code
   - Press Ctrl+Shift+X (Windows/Linux) or Cmd+Shift+X (macOS)
   - Search for "Julia"
   - Install the extension by "Julia"

### Setting Up the Terminal

#### Windows
You have three main options:
1. **PowerShell** (Recommended for VS Code integration)
   ```powershell
   # Check Julia
   julia --version
   
   # Check Git
   git --version
   ```

2. **Git Bash** (Provides Unix-like environment)
   - Installed with Git for Windows
   - Most similar to macOS/Linux experience
   
3. **Command Prompt**
   ```cmd
   :: Check installations
   julia --version
   git --version
   ```

#### macOS/Linux
Open Terminal:
```bash
# Check Julia
julia --version

# Check Git
git --version
```

### Configuring VS Code for Julia

#### Windows
1. Open VS Code settings (File > Preferences > Settings)
2. Search for "Julia"
3. Set "Julia: Executable Path" to:
   ```
   C:\Users\YourUsername\AppData\Local\Programs\Julia-1.9.3\bin\julia.exe
   ```

#### macOS
1. Open VS Code settings (Code > Preferences > Settings)
2. Search for "Julia"
3. Set "Julia: Executable Path" to:
   ```
   /Applications/Julia-1.9.3.app/Contents/Resources/julia/bin/julia
   ```

#### Linux
1. Open VS Code settings
2. Search for "Julia"
3. Set "Julia: Executable Path" to:
   ```
   /usr/local/bin/julia   # or your installation path
   ```

## Git Setup and Configuration

### Installing Git

#### Windows
1. Download Git from [https://git-scm.com/download/win](https://git-scm.com/download/win)
2. During installation:
   - Choose "Git from the command line and also from 3rd-party software"
   - For line endings, select "Checkout Windows-style, commit Unix-style"
   - Choose "Use Windows' default console window" unless you prefer MinTTY

#### macOS
```bash
# Using Homebrew
brew install git

# Or download installer from
# https://git-scm.com/download/mac
```

#### Linux
```bash
# Debian/Ubuntu
sudo apt-get update
sudo apt-get install git

# Fedora
sudo dnf install git

# Arch Linux
sudo pacman -S git
```

### Initial Git Configuration

#### All Platforms
```bash
# Windows (PowerShell/Git Bash) / macOS / Linux
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

Setting up VS Code as default editor:
```bash
# Windows (PowerShell)
git config --global core.editor "'C:/Users/$env:USERNAME/AppData/Local/Programs/Microsoft VS Code/Code.exe' --wait"

# Windows (Git Bash)
git config --global core.editor "'C:/Program Files/Microsoft VS Code/Code.exe' --wait"

# macOS
git config --global core.editor "code --wait"

# Linux
git config --global core.editor "code --wait"
```

### Creating a Julia Project with Git

#### Windows (PowerShell)
```powershell
# Create and navigate to project directory
New-Item -ItemType Directory -Path MyJuliaProject
Set-Location MyJuliaProject
git init

# Start Julia in project mode
julia --project=.
```

#### Windows (Git Bash) / macOS / Linux
```bash
# Create and navigate to project directory
mkdir MyJuliaProject
cd MyJuliaProject
git init

# Start Julia in project mode
julia --project=.
```

### Working with Files

#### Windows (PowerShell)
```powershell
# List files
Get-ChildItem  # or dir
# Create file
New-Item -ItemType File -Path src/example.jl
# Check status
git status
```

#### Windows (Git Bash) / macOS / Linux
```bash
# List files
ls
# Create file
mkdir src
touch src/example.jl
# Check status
git status
```

### Julia-Specific Git Configuration

#### All Platforms
Create `.gitignore`:
```gitignore
# Julia specific
*.jl.cov
*.jl.*.cov
*.jl.mem
deps/deps.jl
Manifest.toml

# OS specific
# Windows
Thumbs.db
[Dd]esktop.ini
# macOS
.DS_Store
# Linux
*~

# VS Code
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
```

## Common Git Operations

### Basic Workflow
Commands are the same across all platforms:
```bash
# Check status
git status

# Stage changes
git add src/example.jl
git add .  # all files

# Commit
git commit -m "Add example code"

# Push to remote
git push origin main
```

### Path Differences

#### Windows (PowerShell)
```powershell
git add .\src\example.jl
```

#### Windows (Git Bash) / macOS / Linux
```bash
git add src/example.jl
```

Note: Git actually accepts both forward slashes and backslashes on Windows, so either style will work.

## VS Code Integration

VS Code's Git integration works identically across platforms:
1. Source Control icon in sidebar
2. Stage changes with '+'
3. Commit with check mark
4. Push/pull with arrows

## Troubleshooting

### Windows-Specific
- If Git is not recognized in PowerShell, restart PowerShell or your computer
- Check if Git is in your PATH: `$env:Path -split ';'`
- PowerShell execution policy issues: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`

### macOS/Linux-Specific
- Check Git installation path: `which git`
- Permission issues: `ls -la ~/.gitconfig`
- SSH key setup: `ssh-keygen -t ed25519 -C "your.email@example.com"`

## Setting Up SSH Authentication for GitHub

SSH keys allow you to connect to GitHub without entering your password each time. Here's how to set it up:

### Checking for Existing SSH Keys

#### Windows (PowerShell/Git Bash)
```bash
ls ~/.ssh
# or
dir ~/.ssh
```

#### macOS/Linux
```bash
ls -la ~/.ssh
```

Look for files named `id_ed25519.pub` or `id_rsa.pub`. If none exist, generate new keys.

### Generating a New SSH Key

#### All Platforms
```bash
# In PowerShell, Git Bash, or Terminal
ssh-keygen -t ed25519 -C "your.email@example.com"

# If you're using a legacy system that doesn't support Ed25519:
ssh-keygen -t rsa -b 4096 -C "your.email@example.com"
```

When prompted:
1. Press Enter to accept the default file location
2. Enter a secure passphrase (recommended) or press Enter for no passphrase

### Starting the SSH Agent

#### Windows (PowerShell)
```powershell
# Start the ssh-agent
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent

# Add your key
ssh-add $env:USERPROFILE\.ssh\id_ed25519
```

#### Windows (Git Bash)
```bash
# Start the ssh-agent
eval "$(ssh-agent -s)"

# Add your key
ssh-add ~/.ssh/id_ed25519
```

#### macOS
```bash
# Start the ssh-agent
eval "$(ssh-agent -s)"

# Add to ~/.ssh/config
touch ~/.ssh/config
nano ~/.ssh/config

# Add these lines:
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519

# Add your key
ssh-add -K ~/.ssh/id_ed25519
```

#### Linux
```bash
# Start the ssh-agent
eval "$(ssh-agent -s)"

# Add your key
ssh-add ~/.ssh/id_ed25519
```

### Adding the SSH Key to GitHub

1. Copy the SSH key to your clipboard:

#### Windows (PowerShell)
```powershell
Get-Content ~/.ssh/id_ed25519.pub | Set-Clipboard
```

#### Windows (Git Bash)
```bash
cat ~/.ssh/id_ed25519.pub | clip
```

#### macOS
```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

#### Linux
```bash
# If you have xclip installed
xclip -sel clip < ~/.ssh/id_ed25519.pub

# Or just display it to copy manually
cat ~/.ssh/id_ed25519.pub
```

2. Add the key to GitHub:
   - Go to GitHub.com and sign in
   - Click your profile photo → Settings
   - In the sidebar, click "SSH and GPG keys"
   - Click "New SSH key" or "Add SSH key"
   - Give your key a descriptive title
   - Paste your key into the "Key" field
   - Click "Add SSH key"

### Testing Your SSH Connection
```bash
# Try connecting to GitHub
ssh -T git@github.com
```

You should see a message like: "Hi username! You've successfully authenticated..."

### Using SSH URLs for Repositories

When cloning or adding remotes, use SSH URLs instead of HTTPS:

```bash
# Instead of HTTPS URL:
# https://github.com/username/repository.git

# Use SSH URL:
git clone git@github.com:username/repository.git

# Change remote URL from HTTPS to SSH:
git remote set-url origin git@github.com:username/repository.git
```

### Troubleshooting SSH

If you have issues:

1. Verify the SSH agent is running:
```bash
ssh-add -l
```

2. Check GitHub's connection:
```bash
ssh -vT git@github.com
```

3. Common issues:
   - Permission denied: Make sure your SSH key is added to the agent
   - Key not found: Check the path to your key
   - Wrong key: Ensure the public key matches what's on GitHub

## Best Practices for Cross-Platform Projects
1. Use `.gitattributes` to handle line endings:
   ```
   * text=auto
   *.jl text
   ```
2. Use relative paths in project configurations
3. Test on both Windows and Unix-like systems when possible
4. Use forward slashes (/) in documentation as they work on all platforms

Remember: Git commands themselves are consistent across platforms. The main differences are in:
- Path separators (though Git handles both styles)
- Terminal commands for file operations
- Line endings (handled by Git configuration)
- Installation and initial setup procedures