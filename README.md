# deb
Various patches and setup scripts for Debian / Raspberry Pi.

## Prerequisites

- Debian 10+ or Raspberry Pi OS (64-bit recommended for Docker stack)
- `git`, `sudo`, `curl` installed
- Internet access for install scripts

## Install (one line)

**Minimal** — clones deb repo only, then run `~/deb/menu`:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/refap3/deb/master/install.sh)
```

**Full bootstrap** — installs git, deb repo, alias dotfiles, Docker (via the official Docker apt source repository), and Portainer:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/refap3/deb/master/install.sh) --full
```

> After `--full`, log out and back in for the docker group to take effect.

## Update

```bash
dbu
```

Pulls the latest changes and strips old history. `dbu` is available once the alias repo is deployed. Or manually:

```bash
git -C ~/deb fetch --depth=1 origin master && git -C ~/deb reset --hard origin/master && git -C ~/deb gc --prune=all
```

## Test a clean install

Wipe the repo and re-run the installer:

```bash
cd ~
rm -rf ~/deb
curl -fsSL https://raw.githubusercontent.com/refap3/deb/master/install.sh | bash
```

## Quick start (manual)

```bash
sudo apt-get install -y git
git clone --depth 1 https://github.com/refap3/deb ~/deb
~/deb/menu
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
| `install_docker` | Adds the official Docker apt source repository, installs Docker CE packages, adds current user to docker group, runs Portainer |
| `uninstall_docker` | Fully removes Docker, all containers, volumes, images, Docker apt source repo, and the docker group |
| `uninstall_full` | Reverses a full bootstrap (Docker + apt source + alias dotfiles) — use before re-testing `--full` |
| `install_dotnet` | Installs .NET Core runtime to `/opt/dotnet` |
| `nodered-install-debian` | Installs Node-RED via official installer, enables systemd service |

### Utilities

| Script | Description |
|--------|-------------|
| `disk_speed_test` | 128 MB read/write benchmark on the current directory; rates result 1–10. Alias: `dst` |
| `map_smb_share` | Mounts a CIFS/SMB share and adds it to `/etc/fstab` — **edit variables at the top before running** |
| `pinginfoview` | Interactive full-screen terminal ping monitor — live status table for a list of hosts/IPs |

---

## pinginfoview — terminal ping monitor

Interactive full-screen terminal tool that pings a list of hosts/IPs and
shows their live status in a table.

```bash
~/deb/pinginfoview              # uses hosts.txt next to the script
~/deb/pinginfoview /path/to/hosts.txt
```

Edit `hosts.txt` — one hostname, FQDN, or IP per line; `#` comments supported:

```
# My network
192.168.1.1      # router
google.com
8.8.8.8
```

**Keys — normal mode**

| Key | Action |
|-----|--------|
| `H` | Sort by hostname (press again to reverse) |
| `I` | Sort by IP address (press again to reverse) |
| `S` | Sort by status (press again to reverse) |
| `T` | Cycle failure-time sort: Last Fail ↑ → ↓ → First Fail ↑ → ↓ |
| `R` | Set refresh interval (default: 2 s) |
| `E` | Edit `hosts.txt` in nano; reloads on save |
| `J` / `↓` | Move selection cursor down |
| `K` / `↑` | Move selection cursor up |
| `D` | Remove highlighted host from the hosts file |
| `N` | Enter **scan mode** (discover live hosts on the current /24 subnet) |
| `Q` / `ESC` | Quit |

**Scan mode** (`N` to enter/exit)

Ignores the hosts file and pings every address on the local /24 subnet.
Only responding hosts are shown, each with a green `✓`.
Reverse-DNS names are resolved once per discovered IP.
Columns match normal mode: HOST, IP, ST, OK/FAIL counts, and the two timestamp ranges (FAIL: FIRST→LAST, OK: FIRST→LAST).
In snapshot mode, hosts that went down remain visible in red with their timestamps preserved.

| Key | Action |
|-----|--------|
| `H` | Sort by hostname/name (press again to reverse) |
| `I` | Sort by IP address (press again to reverse) |
| `S` | Sort by status delta (snapshot) or OK count (scan) |
| `T` | Cycle failure-time sort: Last Fail ↑ → ↓ → First Fail ↑ → ↓ |
| `J` / `↓` | Move selection cursor down |
| `K` / `↑` | Move selection cursor up |
| `A` | Add highlighted host to the active hosts file |
| `P` | Toggle **snapshot mode** |
| `B` | Toggle visibility of unchanged (dim) background hosts *(snapshot mode only)* |
| `N` | Exit scan mode, return to hosts-file view |
| `Q` | Quit |

**Snapshot mode** (`P` in scan mode)

Records the set of live hosts at the moment `P` is pressed, then highlights
changes as they happen:

- **Bright green** — host appeared after the snapshot was taken
- **Bright red** — host was up at snapshot time but is no longer responding
- **Dim** — no change from snapshot baseline

Press `P` again to clear the snapshot and resume the normal scan view.
The status bar shows `[SNAPSHOT HH:MM:SS]` with the time the baseline was taken.
Press `B` to toggle visibility of unchanged (dim) background hosts — useful to focus on
new arrivals and dropouts. The status bar shows `bg:hidden` when they are suppressed.
Confirmed dropouts (hosts that went red since the snapshot) remain visible in red even
when background is hidden, and stay red until `B` is pressed again (resetting their
dropout state) or `P` clears the snapshot. This covers both baseline hosts that went
down and new arrivals that appeared after the snapshot and then disappeared.

**Site auto-detection** (when launched via `piv` alias): each site's nameserver is queried directly —
`192.168.1.203` for `ssb8.local` → `hosts-vienna.txt`, `192.168.1.198` for `pi.hole` → `hosts-aigen.txt`, neither → `hosts.txt`.
Detection uses `dig` (1 s timeout) if available, falls back to `nslookup` with explicit server, then `/dev/tcp` port-53 reachability — works on minimal Pi OS installs without `dnsutils`.
The active site is shown in the status bar as `[VIENNA]` / `[AIGEN]`.
Pass an explicit path to bypass: `piv ~/deb/hosts-vienna.txt`.

Man page: `man ~/deb/man/man1/pinginfoview.1`

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

## Man page

```bash
man deb
```

Requires the [alias](https://github.com/refap3/alias) repo to be installed (it sets `MANPATH`).
Or directly: `man ~/deb/man/man1/deb.1`

---

## Shell dotfiles

Shell dotfiles (zsh/bash aliases, deploy script, etc.) have moved to a dedicated repo:
→ https://github.com/refap3/alias
