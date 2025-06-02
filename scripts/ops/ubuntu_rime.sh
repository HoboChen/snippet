sudo apt install fcitx5 fcitx5-config-qt fcitx5-table-all

echo "GTK_IM_MODULE   DEFAULT=fcitx
QT_IM_MODULE    DEFAULT=fcitx
XMODIFIERS      DEFAULT=@im=fcitx" >> ~/.pam_environment

mkdir -p ~/.config/autostart
cp /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart/