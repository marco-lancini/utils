#-- Gnome Extension - Dash Dock (the toolbar with all the icons)
gsettings set org.gnome.shell favorite-apps \
    "['gnome-terminal.desktop', 'org.gnome.Nautilus.desktop', 'kali-wireshark.desktop', 'firefox-esr.desktop', 'kali-burpsuite.desktop', 'kali-msfconsole.desktop', 'gedit.desktop']"
#-- Gnome Extension - Alternate-tab (So it doesn't group the same windows up)
GNOME_EXTENSIONS=$(gsettings get org.gnome.shell enabled-extensions | sed 's_^.\(.*\).$_\1_')
gsettings set org.gnome.shell enabled-extensions "[${GNOME_EXTENSIONS}, 'alternate-tab@gnome-shell-extensions.gcampax.github.com']"
#-- Gnome Extension - Drive Menu (Show USB devices in tray)
gsettings set org.gnome.shell enabled-extensions "[${GNOME_EXTENSIONS}, 'drive-menu@gnome-shell-extensions.gcampax.github.com']"
#--- Workspaces
gsettings set org.gnome.shell.overrides dynamic-workspaces false                         # Static
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4                          # Increase workspaces count to 3
#--- Top bar
gsettings set org.gnome.desktop.interface clock-show-date true                           # Show date next to time in the top tool bar
