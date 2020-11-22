##### Configuring armitage
export MSF_DATABASE_CONFIG=/usr/share/metasploit-framework/config/database.yml
for file in /etc/bash.bashrc ~/.zshrc; do
  [ ! -e "${file}" ] && continue
  [ -e "${file}" ] && cp -n $file{,.bkup}
  ([[ -e "${file}" && "$(tail -c 1 ${file})" != "" ]]) && echo >> "${file}"
  grep -q 'MSF_DATABASE_CONFIG' "${file}" 2>/dev/null \
    || echo 'MSF_DATABASE_CONFIG=/usr/share/metasploit-framework/config/database.yml\n' >> "${file}"
done