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
