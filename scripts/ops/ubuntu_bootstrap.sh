sudo apt update
sudo apt upgrade -y

sudo apt install sysstat htop iftop wget tmux curl zsh ripgrep \
  lm-sensors pandoc \
  vim git build-essential python3 python3-pip
# sudo apt install gnome-tweak-tool net-tools
# sudo apt install openjdk-17-jdk clang ghc
# sudo apt install texlive-full

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

python3 -m pip install --user --upgrade pip

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
nvm install --lts
npm install tldr -g

