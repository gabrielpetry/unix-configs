#!/bin/bash
timestamp=$(date +"%s")
pwd="$PWD"
dir="$(dirname $0)"

checkFileAndremove() {
    if [[ -d "$1" || -f "$1" || -L "$1" ]]; then
        backup_dir="$HOME/.config/backup/$timestamp"
        # mkdir -p "$backup_dir"
        
        # unlink "$1"
        # mv "$1" "$backup_dir"
    else
        ls -la "$1"
    fi
    
    return 1
}

cd "$dir"
echo "Removing old files"
for module in $(ls -1 | grep -v apply.sh); do
    unlink "$HOME/.config/$module"
    unlink "$HOME/$module"
    stow -v -t "$HOME" "$module"
done

echo "All original files removed"

cd "$pwd"
