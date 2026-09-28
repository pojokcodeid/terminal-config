# Pastikan 'Pass input' di kanan atas Automator diset ke 'as arguments'

# Menambahkan path Homebrew ke environment variabel
export PATH="/opt/homebrew/bin:$PATH"

for f in "$@"; do
    if [ -d "$f" ]; then
        TARGET_DIR="$f"
    else
        TARGET_DIR="$(dirname "$f")"
    fi

    # Eksekusi langsung via binary Homebrew dengan flag --cwd
    /opt/homebrew/bin/wezterm start --cwd "$TARGET_DIR" &> /dev/null &
done
