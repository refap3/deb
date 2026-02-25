# ~/.jump.sh — cd wrapper and j (jump) function for bash and zsh
#
# Cross-shell: avoids zsh-specific modifiers (:l, :A, :h, nested ${})
# and avoids zsh's 1-based vs bash's 0-based array indexing.

# cd wrapper — caches visited directories to ~/.jumplocations
cd() {
    builtin cd "$@" && {
        local dir="$PWD"
        local cache="$HOME/.jumplocations"
        if [ ! -f "$cache" ] || ! grep -qxF "$dir" "$cache"; then
            echo "$dir" >> "$cache"
        fi
    }
}

# Helper: return the nth positional argument (1-based) — avoids index-base differences
_j_nth() {
    local n=$1; shift
    local i=0
    for item; do
        i=$((i+1))
        [ "$i" -eq "$n" ] && { printf '%s' "$item"; return; }
    done
}

# j — jump to a previously-visited directory by partial folder name
j() {
    if [ -z "$1" ]; then
        echo "Usage: j <partial-folder-name>"
        return 1
    fi

    local cache="$HOME/.jumplocations"
    local query
    query=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')

    if [ ! -f "$cache" ]; then
        echo "No cached locations found."
        return 1
    fi

    local -a matches=()
    local -a cleaned=()
    local line segment

    while IFS= read -r line; do
        [ -z "$line" ] && continue
        if [ -d "$line" ]; then
            cleaned+=("$line")
            segment=$(basename "$line" | tr '[:upper:]' '[:lower:]')
            case "$segment" in
                *"$query"*) matches+=("$line") ;;
            esac
        fi
        # Entries for non-existent dirs are silently dropped
    done < "$cache"

    # Rewrite cache: existing dirs only, deduplicated, preserving order
    printf '%s\n' "${cleaned[@]}" | awk '!seen[$0]++' > "$cache"

    local count=${#matches[@]}

    if [ "$count" -eq 0 ]; then
        echo "No match found for: $1"
        return 1
    elif [ "$count" -eq 1 ]; then
        builtin cd "$(_j_nth 1 "${matches[@]}")"
    else
        echo "Multiple matches:"
        local i=1
        while [ "$i" -le "$count" ]; do
            echo "  $i) $(_j_nth "$i" "${matches[@]}")"
            i=$((i+1))
        done
        printf 'Select [1-%d]: ' "$count"
        local selection
        read -r selection
        case "$selection" in
            ''|*[!0-9]*)
                echo "Invalid selection."
                return 1
                ;;
        esac
        if [ "$selection" -ge 1 ] && [ "$selection" -le "$count" ]; then
            builtin cd "$(_j_nth "$selection" "${matches[@]}")"
        else
            echo "Invalid selection."
            return 1
        fi
    fi
}
