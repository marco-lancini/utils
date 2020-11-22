#--- Configure atftpd
file=/etc/default/atftpd
echo 'USE_INETD=false\nOPTIONS="--tftpd-timeout 300 --retry-timeout 5 --maxthread 100 --verbose=5 --daemon --port 69 /var/tftp"' > "${file}"
mkdir -p /var/tftp/
chown -R nobody\:root /var/tftp/
chmod -R 0755 /var/tftp/
#--- Setup alias
file=~/.bash_aliases
grep -q '^## tftp' "${file}" 2>/dev/null \
  || echo '## tftp\nalias tftproot="cd /var/tftp/"\n' >> "${file}"
#--- Apply new alias
source "${file}" || source ~/.zshrc
#--- Remove from start up
systemctl disable atftpd
#--- Disabling IPv6 can help
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6