#!/bin/bash
timestamp=$(date +"%s")
oldpwd="$PWD"
dir="$(dirname "$0")"

backup_dir="$HOME/.backup/dotfiles-$timestamp"

mkdir -p "$backup_dir"
echo "=====================Dotfiles Manager================="
echo "Changing working dir to $dir"
cd "$dir" || exit 1

for module in *; do
    [ "$module" = "apply.sh" ] && continue
    echo "module $module"
    test -L "$HOME/.config/$module" && unlink "$HOME/.config/$module" 2>/dev/null
    test -L "$HOME/$module" && unlink "$HOME/$module" 2>/dev/null

    mv "$HOME/.config/$module" "$backup_dir" 2>/dev/null
    mv "$HOME/$module" "$backup_dir" 2>/dev/null

    rootfiles="$(find "$module" -type f -maxdepth 1)"

    # if this modules saves files to root, we move then
    if [ -n "$rootfiles" ]; then
      for file in $rootfiles; do 
        mv "$HOME/${file//"$module"\//}" "$backup_dir"
      done
    fi
        
    stow -v -t "$HOME" "$module"
    echo "---------"
done

echo "Changing working dir to $dir"
cd "$oldpwd" || exit 1
