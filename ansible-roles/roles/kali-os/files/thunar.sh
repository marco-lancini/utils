#--- Settings
mkdir -p ~/.config/gtk-2.0/
file=~/.config/gtk-2.0/gtkfilechooser.ini;
([[ -e "${file}" && "$(tail -c 1 ${file})" != "" ]]) && echo >> "${file}"
sed -i 's/^.*ShowHidden.*/ShowHidden=true/' "${file}" 2>/dev/null \
  || cat <<EOF > "${file}"
[Filechooser Settings]
LocationMode=path-bar
ShowHidden=true
ExpandFolders=false
ShowSizeColumn=true
GeometryX=66
GeometryY=39
GeometryWidth=780
GeometryHeight=618
SortColumn=name
SortOrder=ascending
EOF

#--- Bookmarks
file=/root/.gtk-bookmarks
echo 'file:///root/Downloads Downloads' >> "${file}"
echo 'file:///mnt/hgfs VMShare' >> "${file}"
echo 'file:///tmp /TMP' >> "${file}"
echo 'file:///usr/share Kali Tools' >> "${file}"
echo 'file:///opt /opt' >> "${file}"
echo 'file:///usr/local/src SRC' >> "${file}"
echo 'file:///var/ftp FTP' >> "${file}"
echo 'file:///var/samba Samba' >> "${file}"
echo 'file:///var/tftp TFTP' >> "${file}"
echo 'file:///var/www/html WWW' >> "${file}"

#--- Configure file browser - Thunar (need to re-login for effect)
mkdir -p ~/.config/Thunar/
file=~/.config/Thunar/thunarrc
sed -i 's/LastShowHidden=.*/LastShowHidden=TRUE/' "${file}" 2>/dev/null \
  || echo "[Configuration]\nLastShowHidden=TRUE" > "${file}"
