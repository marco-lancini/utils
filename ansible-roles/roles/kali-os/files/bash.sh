##### Configure bash - all users
pip install psutil
file=/etc/bash.bashrc
grep -q "cdspell" "${file}" \
    || echo "shopt -sq cdspell" >> "${file}"             # Spell check 'cd' commands
grep -q "autocd" "${file}" \
    || echo "shopt -s autocd" >> "${file}"                # So you don't have to 'cd' before a folder
grep -q "checkwinsize" "${file}" \
    || echo "shopt -sq checkwinsize" >> "${file}"         # Wrap lines correctly after resizing
grep -q "nocaseglob" "${file}" \
    || echo "shopt -sq nocaseglob" >> "${file}"           # Case insensitive pathname expansion
grep -q "HISTSIZE" "${file}" \
    || echo "HISTSIZE=10000" >> "${file}"                 # Bash history (memory scroll back)
grep -q "HISTFILESIZE" "${file}" \
    || echo "HISTFILESIZE=10000" >> "${file}"             # Bash history (file .bash_history)

##### Install bash colour - all users
file=/etc/bash.bashrc
([[ -e "${file}" && "$(tail -c 1 ${file})" != "" ]]) && echo >> "${file}"
sed -i 's/.*force_color_prompt=.*/force_color_prompt=yes/' "${file}"
grep -q '^force_color_prompt' "${file}" 2>/dev/null \
    || echo 'force_color_prompt=yes' >> "${file}"
sed -i 's#PS1='"'"'.*'"'"'#PS1='"'"'${debian_chroot:+($debian_chroot)}\\[\\033\[01;31m\\]\\u@\\h\\\[\\033\[00m\\]:\\[\\033\[01;34m\\]\\w\\[\\033\[00m\\]\\$ '"'"'#' "${file}"
grep -q "^export LS_OPTIONS='--color=auto'" "${file}" 2>/dev/null \
    || echo "export LS_OPTIONS='--color=auto'" >> "${file}"
grep -q '^eval "$(dircolors)"' "${file}" 2>/dev/null \
    || echo 'eval "$(dircolors)"' >> "${file}"
grep -q "^alias ls='ls $LS_OPTIONS'" "${file}" 2>/dev/null \
    || echo "alias ls='ls $LS_OPTIONS'" >> "${file}"
grep -q "^alias ll='ls $LS_OPTIONS -l'" "${file}" 2>/dev/null \
    || echo "alias ll='ls $LS_OPTIONS -l'" >> "${file}"
grep -q "^alias l='ls $LS_OPTIONS -lA'" "${file}" 2>/dev/null \
    || echo "alias l='ls $LS_OPTIONS -lA'" >> "${file}"
#--- All other users that are made afterwards
file=/etc/skel/.bashrc
sed -i 's/.*force_color_prompt=.*/force_color_prompt=yes/' "${file}"

##### Install grc
apt -y -qq install grc
#--- Setup aliases
file=~/.bash_aliases
([[ -e "${file}" && "$(tail -c 1 ${file})" != "" ]]) && echo >> "${file}"
grep -q '^## grc diff alias' "${file}" 2>/dev/null \
    || echo "## grc diff alias\nalias diff='$(which grc) $(which diff)'\n" >> "${file}"
grep -q '^## grc dig alias' "${file}" 2>/dev/null \
    || echo "## grc dig alias\nalias dig='$(which grc) $(which dig)'\n" >> "${file}"
grep -q '^## grc gcc alias' "${file}" 2>/dev/null \
    || echo "## grc gcc alias\nalias gcc='$(which grc) $(which gcc)'\n" >> "${file}"
grep -q '^## grc ifconfig alias' "${file}" 2>/dev/null \
    || echo "## grc ifconfig alias\nalias ifconfig='$(which grc) ifconfig'\n" >> "${file}"
grep -q '^## grc mount alias' "${file}" 2>/dev/null \
    || echo "## grc mount alias\nalias mount='$(which grc) $(which mount)'\n" >> "${file}"
grep -q '^## grc netstat alias' "${file}" 2>/dev/null \
    || echo "## grc netstat alias\nalias netstat='$(which grc) netstat'\n" >> "${file}"
grep -q '^## grc ping alias' "${file}" 2>/dev/null \
    || echo "## grc ping alias\nalias ping='$(which grc) $(which ping)'\n" >> "${file}"
grep -q '^## grc ps alias' "${file}" 2>/dev/null \
    || echo "## grc ps alias\nalias ps='$(which grc) $(which ps)'\n" >> "${file}"
grep -q '^## grc tail alias' "${file}" 2>/dev/null \
    || echo "## grc tail alias\nalias tail='$(which grc) $(which tail)'\n" >> "${file}"
grep -q '^## grc traceroute alias' "${file}" 2>/dev/null \
    || echo "## grc traceroute alias\nalias traceroute='$(which grc) $(which traceroute)'\n" >> "${file}"
grep -q '^## grc wdiff alias' "${file}" 2>/dev/null \
    || echo "## grc wdiff alias\nalias wdiff='$(which grc) $(which wdiff)'\n" >> "${file}"

##### Install bash completion - all users
apt -y -qq install bash-completion \
file=/etc/bash.bashrc
sed -i '/# enable bash completion in/,+7{/enable bash completion/!s/^#//}' "${file}"

##### Configure aliases - root user
#--- Enable defaults - root user
for FILE in /etc/bash.bashrc ~/.bashrc ~/.bash_aliases; do    #/etc/profile /etc/bashrc /etc/bash_aliases /etc/bash.bash_aliases
  [[ ! -f "${FILE}" ]] \
    && continue
  cp -n $FILE{,.bkup}
  sed -i 's/#alias/alias/g' "${FILE}"
done
#--- General system ones
file=~/.bash_aliases
([[ -e "${file}" && "$(tail -c 1 ${file})" != "" ]]) && echo >> "${file}"
grep -q '^## grep aliases' "${file}" 2>/dev/null \
  || echo '## grep aliases\nalias grep="grep --color=always"\nalias ngrep="grep -n"\n' >> "${file}"
grep -q '^alias egrep=' "${file}" 2>/dev/null \
  || echo 'alias egrep="egrep --color=auto"\n' >> "${file}"
grep -q '^alias fgrep=' "${file}" 2>/dev/null \
  || echo 'alias fgrep="fgrep --color=auto"\n' >> "${file}"
#--- Add in ours (OS programs)
grep -q '^alias tmux' "${file}" 2>/dev/null \
  || echo '## tmux\nalias tmux="tmux attach || tmux new"\n' >> "${file}"    #alias tmux="tmux attach -t $HOST || tmux new -s $HOST"
grep -q '^alias axel' "${file}" 2>/dev/null \
  || echo '## axel\nalias axel="axel -a"\n' >> "${file}"
grep -q '^alias screen' "${file}" 2>/dev/null \
  || echo '## screen\nalias screen="screen -xRR"\n' >> "${file}"
#--- Add in ours (shortcuts)
grep -q '^## Checksums' "${file}" 2>/dev/null \
  || echo '## Checksums\nalias sha1="openssl sha1"\nalias md5="openssl md5"\n' >> "${file}"
grep -q '^## Force create folders' "${file}" 2>/dev/null \
  || echo '## Force create folders\nalias mkdir="/bin/mkdir -pv"\n' >> "${file}"
#grep -q '^## Mount' "${file}" 2>/dev/null \
#  || echo '## Mount\nalias mount="mount | column -t"\n' >> "${file}"
grep -q '^## List open ports' "${file}" 2>/dev/null \
  || echo '## List open ports\nalias ports="netstat -tulanp"\n' >> "${file}"
grep -q '^## Get header' "${file}" 2>/dev/null \
  || echo '## Get header\nalias header="curl -I"\n' >> "${file}"
grep -q '^## Get external IP address' "${file}" 2>/dev/null \
  || echo '## Get external IP address\nalias ipx="curl -s http://ipinfo.io/ip"\n' >> "${file}"
grep -q '^## DNS - External IP #1' "${file}" 2>/dev/null \
  || echo '## DNS - External IP #1\nalias dns1="dig +short @resolver1.opendns.com myip.opendns.com"\n' >> "${file}"
grep -q '^## DNS - External IP #2' "${file}" 2>/dev/null \
  || echo '## DNS - External IP #2\nalias dns2="dig +short @208.67.222.222 myip.opendns.com"\n' >> "${file}"
grep -q '^## DNS - Check' "${file}" 2>/dev/null \
  || echo '### DNS - Check ("#.abc" is Okay)\nalias dns3="dig +short @208.67.220.220 which.opendns.com txt"\n' >> "${file}"
grep -q '^## Directory navigation aliases' "${file}" 2>/dev/null \
  || echo '## Directory navigation aliases\nalias ..="cd .."\nalias ...="cd ../.."\nalias ....="cd ../../.."\nalias .....="cd ../../../.."\n' >> "${file}"
grep -q '^## Extract file' "${file}" 2>/dev/null \
  || cat <<EOF >> "${file}" \
    || echo ' '${RED}'[!] Issue with writing file'${RESET} 1>&2

## Extract file, example. "ex package.tar.bz2"
ex() {
  if [[ -f \$1 ]]; then
    case \$1 in
      *.tar.bz2) tar xjf \$1 ;;
      *.tar.gz)  tar xzf \$1 ;;
      *.bz2)     bunzip2 \$1 ;;
      *.rar)     rar x \$1 ;;
      *.gz)      gunzip \$1  ;;
      *.tar)     tar xf \$1  ;;
      *.tbz2)    tar xjf \$1 ;;
      *.tgz)     tar xzf \$1 ;;
      *.zip)     unzip \$1 ;;
      *.Z)       uncompress \$1 ;;
      *.7z)      7z x \$1 ;;
      *)         echo \$1 cannot be extracted ;;
    esac
  else
    echo \$1 is not a valid file
  fi
}
EOF
grep -q '^## strings' "${file}" 2>/dev/null \
  || echo '## strings\nalias strings="strings -a"\n' >> "${file}"
grep -q '^## history' "${file}" 2>/dev/null \
  || echo '## history\nalias hg="history | grep"\n' >> "${file}"
grep -q '^## Network Services' "${file}" 2>/dev/null \
  || echo '### Network Services\nalias listen="netstat -antp | grep LISTEN"\n' >> "${file}"
grep -q '^## HDD size' "${file}" 2>/dev/null \
  || echo '### HDD size\nalias hogs="for i in G M K; do du -ah | grep [0-9]$i | sort -nr -k 1; done | head -n 11"\n' >> "${file}"
grep -q '^## Listing' "${file}" 2>/dev/null \
  || echo '### Listing\nalias ll="ls -l --block-size=1 --color=auto"\n' >> "${file}"
#--- Add in tools
grep -q '^## nmap' "${file}" 2>/dev/null \
  || echo '## nmap\nalias nmap="nmap --reason --open --stats-every 3m --max-retries 1 --max-scan-delay 20 --defeat-rst-ratelimit"\n' >> "${file}"
grep -q '^## aircrack-ng' "${file}" 2>/dev/null \
  || echo '## aircrack-ng\nalias aircrack-ng="aircrack-ng -z"\n' >> "${file}"
grep -q '^## airodump-ng' "${file}" 2>/dev/null \
  || echo '## airodump-ng \nalias airodump-ng="airodump-ng --manufacturer --wps --uptime"\n' >> "${file}"
grep -q '^## metasploit' "${file}" 2>/dev/null \
  || (echo '## metasploit\nalias msfc="systemctl start postgresql; msfdb start; msfconsole -q \"\$@\""' >> "${file}" \
    && echo 'alias msfconsole="systemctl start postgresql; msfdb start; msfconsole \"\$@\""\n' >> "${file}" )
grep -q '^## ssh' "${file}" 2>/dev/null \
  || echo '## ssh\nalias ssh-start="systemctl restart ssh"\nalias ssh-stop="systemctl stop ssh"\n' >> "${file}"
grep -q '^## samba' "${file}" 2>/dev/null \
  || echo '## samba\nalias smb-start="systemctl restart smbd nmbd"\nalias smb-stop="systemctl stop smbd nmbd"\n' >> "${file}"
grep -q '^## rdesktop' "${file}" 2>/dev/null \
  || echo '## rdesktop\nalias rdesktop="rdesktop -z -P -g 90% -r disk:local=\"/tmp/\""\n' >> "${file}"
#--- Add in folders
grep -q '^## www' "${file}" 2>/dev/null \
  || echo '## www\nalias wwwroot="cd /var/www/html/"\n#alias www="cd /var/www/html/"\n' >> "${file}"
grep -q '^## ftp' "${file}" 2>/dev/null \
  || echo '## ftp\nalias ftproot="cd /var/ftp/"\n' >> "${file}"
grep -q '^## tftp' "${file}" 2>/dev/null \
  || echo '## tftp\nalias tftproot="cd /var/tftp/"\n' >> "${file}"
grep -q '^## smb' "${file}" 2>/dev/null \
  || echo '## smb\nalias smb="cd /var/samba/"\n#alias smbroot="cd /var/samba/"\n' >> "${file}"
(dmidecode | grep -iq vmware) \
  && (grep -q '^## vmware' "${file}" 2>/dev/null \
    || echo '## vmware\nalias vmroot="cd /mnt/hgfs/"\n' >> "${file}")
grep -q '^## edb' "${file}" 2>/dev/null \
  || echo '## edb\nalias edb="cd /usr/share/exploitdb/platforms/"\nalias edbroot="cd /usr/share/exploitdb/platforms/"\n' >> "${file}"
grep -q '^## wordlist' "${file}" 2>/dev/null \
  || echo '## wordlist\nalias wordlists="cd /usr/share/wordlists/"\n' >> "${file}"
