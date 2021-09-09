#!/usr/bin/env sh
mirage=$(echo "$PWD" | sed 's_/_\\/_g')

if [ "$(uname)" = "Darwin" ]; then
    sed -i -e 's/BASH_IT_THEME=.*/BASH_IT_THEME='"$mirage\\/mirage.theme.bash"'/g' ~/.bash_profile
else
    sed -i -e 's/BASH_IT_THEME=.*/BASH_IT_THEME='"$mirage\\/mirage.theme.bash"'/g'  ~/.bashrc
fi
