#--- Create samba user
groupdel smbgroup 2>/dev/null;
groupadd smbgroup
userdel samba 2>/dev/null;
useradd -r -M -d /nonexistent -s /bin/false -c "Samba user" -g smbgroup samba
#--- Use the samba user
file=/etc/samba/smb.conf
sed -i 's/guest account = .*/guest account = samba/' "${file}" 2>/dev/null
grep -q 'guest account' "${file}" 2>/dev/null \
  || sed -i 's#\[global\]#\[global\]\n   guest account = samba#' "${file}"
#--- Setup samba paths
grep -q '^\[shared\]' "${file}" 2>/dev/null \
  || cat <<EOF >> "${file}"

[shared]
  comment = Shared
  path = /var/samba/
  browseable = yes
  guest ok = yes
  #guest only = yes
  read only = no
  writable = yes
  create mask = 0644
  directory mask = 0755
EOF
#--- Create samba path and configure it
mkdir -p /var/samba/
chown -R samba\:smbgroup /var/samba/
chmod -R 0755 /var/samba/
#--- Bug fix
touch /etc/printcap
#--- Check
#systemctl restart samba
#smbclient -L \\127.0.0.1 -N
#mount -t cifs -o guest //127.0.0.1/share /mnt/smb     mkdir -p /mnt/smb
#--- Disable samba at startup
sudo systemctl stop smbd nmbd
sudo systemctl disable smbd nmbd
#--- Setup alias
file=~/.bash_aliases
grep -q '^## smb' "${file}" 2>/dev/null \
  || echo '## smb\nalias smb="cd /var/samba/"\n#alias smbroot="cd /var/samba/"\n' >> "${file}"
#--- Apply new alias
source "${file}" || source ~/.zshrc

