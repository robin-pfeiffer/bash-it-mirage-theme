# Bash-it Mirage Theme

## Features

- Show sudo timestamp file

## Installation

This assumes that you have Bash-it already installed and set up. If you have not done so, then follow the instructions on [their page](https://github.com/Bash-it/bash-it#installation)

```sh
git clone git@github.com:robin-pfeiffer/bash-it-mirage-theme.git
cd bash-it-mirage-theme
./install.sh
bash-it restart
```

## Development

```sh
  # Fedora/CentOS
sudo dnf install ShellCheck
  # Ubuntu/Debian
sudo apt install spellcheck 
```

After making changes to `mirage.theme.bash` run `shellcheck mirage.theme.bash` and fix any errors or warnings before committing.
