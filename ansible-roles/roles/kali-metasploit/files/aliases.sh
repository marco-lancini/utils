#--- Fix ports
sed -i 's/port = .* #/port = 5432 /' "$(find /etc/postgresql/*/main/ -maxdepth 1 -type f -name postgresql.conf -print -quit)"

#--- Aliases time
file=~/.bash_aliases
#--- Aliases for console
grep -q '^alias msfc=' "${file}" 2>/dev/null \
    echo 'alias msfc="systemctl start postgresql; msfdb start; msfconsole -q \"\$@\""' >> "${file}"
grep -q '^alias msfconsole=' "${file}" 2>/dev/null \
  | echo 'alias msfconsole="systemctl start postgresql; msfdb start; msfconsole \"\$@\""\n' >> "${file}"
#--- Aliases to speed up msfvenom (create static output)
grep -q "^alias msfvenom-list-all" "${file}" 2>/dev/null \
  | echo "alias msfvenom-list-all='cat ~/.msf4/msfvenom/all'" >> "${file}"
grep -q "^alias msfvenom-list-nops" "${file}" 2>/dev/null \
  | echo "alias msfvenom-list-nops='cat ~/.msf4/msfvenom/nops'" >> "${file}"
grep -q "^alias msfvenom-list-payloads" "${file}" 2>/dev/null \
  | echo "alias msfvenom-list-payloads='cat ~/.msf4/msfvenom/payloads'" >> "${file}"
grep -q "^alias msfvenom-list-encoders" "${file}" 2>/dev/null \
  | echo "alias msfvenom-list-encoders='cat ~/.msf4/msfvenom/encoders'" >> "${file}"
grep -q "^alias msfvenom-list-formats" "${file}" 2>/dev/null \
  | echo "alias msfvenom-list-formats='cat ~/.msf4/msfvenom/formats'" >> "${file}"
grep -q "^alias msfvenom-list-generate" "${file}" 2>/dev/null \
  | echo "alias msfvenom-list-generate='_msfvenom-list-generate'" >> "${file}"
grep -q "^function _msfvenom-list-generate" "${file}" 2>/dev/null \
  | cat <<EOF >> "${file}" \
    || echo ' '${RED}'[!] Issue with writing file'${RESET} 1>&2
function _msfvenom-list-generate {
  mkdir -p ~/.msf4/msfvenom/
  msfvenom --list > ~/.msf4/msfvenom/all
  msfvenom --list nops > ~/.msf4/msfvenom/nops
  msfvenom --list payloads > ~/.msf4/msfvenom/payloads
  msfvenom --list encoders > ~/.msf4/msfvenom/encoders
  msfvenom --list formats > ~/.msf4/msfvenom/formats
}
EOF
