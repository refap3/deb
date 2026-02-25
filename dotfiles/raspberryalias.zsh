# Raspberry Pi SSH/SFTP aliases for zsh
# Converted from raspberryalias.dat (PuTTY/WinSCP → ssh/sftp)
#
# Keys: id_rsa / id_rsa.pub in the dotfiles folder (OpenSSH format)

DOTFILES="${DOTFILES:-$HOME/Library/Mobile Documents/com~apple~CloudDocs/dotfiles}"
PI_KEY="$DOTFILES/id_rsa"

# iCloud Drive does not preserve file permissions, so fix the key before every use
_pikey() { chmod 600 "$PI_KEY" 2>/dev/null; }

# --- Help ---
rah() { clear; echo "USE breevy ras for pw!"; echo "ra Put|Win [P] Vie|Aig"; echo "----------------------------"; cat "$DOTFILES/raspberryalias.zsh"; }

# --- SSH: pi user, by IP (last octet as argument) ---
rap()   { _pikey; ssh -i "$PI_KEY" pi@192.168.1.$1; }   # rap  <octet>  — with key
rapp()  { ssh pi@192.168.1.$1; }                 # rapp <octet>  — without key

# --- SSH: pi user, by hostname ---
rapv()  { _pikey; ssh -i "$PI_KEY" pi@$1.ssb8.local; }  # rapv  <host>  — with key
rappv() { ssh pi@$1.ssb8.local; }                        # rappv <host>  — without key
rapa()  { _pikey; ssh -i "$PI_KEY" pi@$1.pi.hole; }     # rapa  <host>  — with key
rappa() { ssh pi@$1.pi.hole; }                           # rappa <host>  — without key

# --- SSH: root/hassio, port 22222 ---
raphav() { _pikey; ssh -p 22222 -i "$PI_KEY" root@hassio.ssb8.local; }
raphaa() { _pikey; ssh -p 22222 -i "$PI_KEY" root@hassio.pi.hole; }

# --- SFTP: pi user (WinSCP equivalent) ---
raw()   { _pikey; sftp -i "$PI_KEY" pi@192.168.1.$1; }  # raw  <octet>  — with key
rawv()  { _pikey; sftp -i "$PI_KEY" pi@$1.ssb8.local; } # rawv  <host>  — with key
rawa()  { _pikey; sftp -i "$PI_KEY" pi@$1.pi.hole; }    # rawa  <host>  — with key
rawpv() { sftp pi@$1.ssb8.local; }              # rawpv <host>  — without key
rawpa() { sftp pi@$1.pi.hole; }                 # rawpa <host>  — without key


