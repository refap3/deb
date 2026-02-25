# deb
Various patches and setup scripts for Debian, plus shell dotfiles for zsh/bash.

new menu script for main functions

patch_xxx patches feature xxx
install_xxx install feature xxx

new: ssh with key only // and password

remaining files are sources

### notes on dotnet: 

do this to run Hello World as .net CONSOLE app:

mkdir hwapp

cd hwapp

dotnet new

dotnet restore

dotnet run

if you got the same FW version on windows -- copy the project.dll and project.runtimeconfig.json file to Linux and run with dotnet project.dll!


### notes on debACOxx machine setup:

see readME_DEBACO_setup.txt

### check iptables with nmap from same or another host -- this is the expected result:


sudo nmap 78.xx.xx.xx

PORT    STATE    SERVICE

22/tcp  open     ssh

111/tcp filtered rpcbind


#----------------------------------------------

sudo apt update

sudo apt install git -y

git config --global credential.helper store

git config --global user.email "refap3@gmail.com"

git config --global user.name "lecc oreshheFROMap3"


#

mkdir deb

cd ~

git clone https://github.com/refap3/deb 

./deb/menu

#

There is a install_docker, docker-compose, portainer and a docker-compose.yaml file for ntopng, influxdb and grafana
do this:

sudo ~/deb/install_docker

cd ~/deb/

docker-compose up -d


---

## Shell dotfiles (zsh / bash)

The `dotfiles/` directory contains a portable shell configuration that works on macOS and Linux.

**Files:**

| File | Purpose |
|------|---------|
| `.zshrc` | zsh config — sets `DOTFILES`, loads alias files, defines `j` jump function |
| `.bashrc` | bash config — sets `DOTFILES` via `readlink`, loads alias files |
| `gitalias.zsh` | Git shortcuts (load on demand with `gital`) |
| `aliases.zsh` | General aliases (`up`, `home`, `cls`, `dt`, `def`, etc.) |
| `raspberryalias.zsh` | SSH/SFTP aliases for Raspberry Pi hosts |
| `jump.sh` | Directory jump function (`j`) |
| `deploy.sh` | Install script — handles 4 variants: zsh/bash × home-dir/custom-dir |

### Deploy

```bash
git clone https://github.com/refap3/deb ~/deb
cd ~/deb/dotfiles
./deploy.sh [--shell zsh|bash] [--home | --path <dir>]
```

**Examples:**

```bash
# zsh — symlink rc and helpers directly from ~/
./deploy.sh --shell zsh --home

# bash — use a custom dotfiles dir (e.g. ~/dots), then link from ~/
./deploy.sh --shell bash --path ~/dots

# auto-detects current shell if --shell is omitted
./deploy.sh --home
```

The script backs up any existing regular file (e.g. `~/.zshrc.bak.20250225_151900`) before creating symlinks, and is self-locating — works from any clone path.

### Usage after deploy

**General aliases** (loaded automatically on shell start):

| Command | Description |
|---------|-------------|
| `up` | `cd ..` |
| `home` / `hom` | `cd ~` |
| `cls` | Clear screen |
| `dt` | List files created/modified today in current dir |
| `def <name>` | Show definition of any alias or function |
| `x` | Open current directory in Finder |
| `np <file>` | Open file in TextEdit |
| `ia` | Network info (`ifconfig`) |
| `ff <name>` | Find file by name (skips hidden dirs) |
| `fff <name>` | Find file by name (includes hidden) |

**Git aliases** are not loaded automatically (keeps startup fast). Load them on demand:

```bash
gital       # sources ~/.gitalias.zsh and confirms
gh          # list all git aliases
```







