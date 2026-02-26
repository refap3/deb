# deb
Various patches and setup scripts for Debian / Raspberry Pi.

## Prerequisites

- Debian 10+ or Raspberry Pi OS (64-bit recommended for Docker stack)
- `git`, `sudo`, `curl` installed
- Internet access for install scripts

## Quick start

```bash
sudo apt update && sudo apt install git -y
git clone https://github.com/refap3/deb
./deb/menu
```

## Scripts

### Interactive menu

| Script | Description |
|--------|-------------|
| `menu` | Main interactive menu — run this first |
| `snippets_aigen_hass_routing` | Home Assistant gateway switching menu (JuiceSSH / Terminius) |

### SSH patches

| Script | Description |
|--------|-------------|
| `patch_sshkeys` | Installs `authorized_keys` to `~/.ssh/` with correct permissions |
| `patch_ssh_only` | Disables password auth in sshd; key-only login |
| `patch_ssh_password` | Re-enables password auth in sshd |
| `patch_remove_password_warning` | Removes `/etc/profile.d/sshpwd.sh` warning |

**Rollback:** To re-enable password auth after `patch_ssh_only`, run `patch_ssh_password`.

### Sudo patches

| Script | Description |
|--------|-------------|
| `patch_sudo` | Installs sudo, adds `debian8` user to sudo group |
| `ub_patch_sudo` | Ubuntu: appends NOPASSWD rule to `/etc/sudoers` |

### Firewall

| Script | Description |
|--------|-------------|
| `patch_iptables` | Installs iptables rules and hooks them into `if-pre-up.d` |
| `iptables` | Loader script placed at `/etc/network/if-pre-up.d/iptables` |
| `iptables.up.rules` | Rule definitions: drops TCP/UDP port 111 (rpcbind), allows all else |

### Installation scripts

| Script | Description |
|--------|-------------|
| `install_docker` | Installs Docker, docker-compose, adds `pi` to docker group, runs Portainer |
| `install_dotnet` | Installs .NET Core runtime to `/opt/dotnet` |
| `nodered-install-debian` | Installs Node-RED via official installer, enables systemd service |

### Utilities

| Script | Description |
|--------|-------------|
| `map_smb_share` | Mounts a CIFS/SMB share and adds it to `/etc/fstab` — **edit variables at the top before running** |

---

## Docker monitoring stack (ntopng + InfluxDB + Grafana)

```bash
sudo ~/deb/install_docker
# log out and back in so docker group applies
cd ~/deb
docker-compose up -d
```

Services:
- **ntopng** — network traffic monitor, host network mode (requires `ntopng.license`)
- **InfluxDB 2.7** — time-series DB on port `8086`. First run: open `http://<host>:8086` to complete setup.
- **Grafana 11** — dashboards on port `4000` → `http://<host>:4000`

---

## .NET Hello World

```bash
mkdir hwapp && cd hwapp
dotnet new
dotnet restore
dotnet run
```

Or copy `project.dll` + `project.runtimeconfig.json` from a matching Windows build and run with `dotnet project.dll`.

---

## DEBACO machine setup

See `readME_DEBACO_setup.txt`. Summary: install git, clone repo, run `patch_sudo`, `patch_iptables`, `patch_sshkeys`.

---

## Verify iptables with nmap

Expected result after running `patch_iptables`:

```
sudo nmap <host-ip>

PORT    STATE    SERVICE
22/tcp  open     ssh
111/tcp filtered rpcbind
```

All other ports should be closed or filtered.

---

## Shell dotfiles

Shell dotfiles (zsh/bash aliases, deploy script, etc.) have moved to a dedicated repo:
→ https://github.com/refap3/alias
