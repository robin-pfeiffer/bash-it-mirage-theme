#!/usr/bin/env sh

theme=$(echo "$BASH_IT_THEME" | sed 's_/_\\/_g')
mirage=$(echo "$PWD" | sed 's_/_\\/_g')

if [ "$(uname)" == "Darwin" ]; then
    sed -i 's/'"$theme"'/'"$mirage\\/mirage.theme.bash"'/g' ~/.bash_profile
else
    sed -i 's/'"$theme"'/'"$mirage\\/mirage.theme.bash"'/g' ~/.bashrc
fi
