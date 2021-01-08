#--- Configure firefox
export DISPLAY=:0.0
timeout 15 firefox >/dev/null 2>&1                # Start and kill. Files needed for first time run
timeout 5 killall -9 -q -w firefox-esr >/dev/null
file=$(find ~/.mozilla/firefox/*.default*/ -maxdepth 1 -type f -name 'prefs.js' -print -quit)

sed -i 's/^.network.proxy.socks_remote_dns.*/user_pref("network.proxy.socks_remote_dns", true);' "${file}" 2>/dev/null \
  || echo 'user_pref("network.proxy.socks_remote_dns", true);' >> "${file}"
sed -i 's/^.browser.safebrowsing.enabled.*/user_pref("browser.safebrowsing.enabled", false);' "${file}" 2>/dev/null \
  || echo 'user_pref("browser.safebrowsing.enabled", false);' >> "${file}"
sed -i 's/^.browser.safebrowsing.malware.enabled.*/user_pref("browser.safebrowsing.malware.enabled", false);' "${file}" 2>/dev/null \
  || echo 'user_pref("browser.safebrowsing.malware.enabled", false);' >> "${file}"
sed -i 's/^.browser.safebrowsing.remoteLookups.enabled.*/user_pref("browser.safebrowsing.remoteLookups.enabled", false);' "${file}" 2>/dev/null \
  || echo 'user_pref("browser.safebrowsing.remoteLookups.enabled", false);' >> "${file}"
sed -i 's/^.*browser.startup.page.*/user_pref("browser.startup.page", 0);' "${file}" 2>/dev/null \
  || echo 'user_pref("browser.startup.page", 0);' >> "${file}"
sed -i 's/^.*privacy.donottrackheader.enabled.*/user_pref("privacy.donottrackheader.enabled", true);' "${file}" 2>/dev/null \
  || echo 'user_pref("privacy.donottrackheader.enabled", true);' >> "${file}"
sed -i 's/^.*browser.showQuitWarning.*/user_pref("browser.showQuitWarning", true);' "${file}" 2>/dev/null \
  || echo 'user_pref("browser.showQuitWarning", true);' >> "${file}"
sed -i 's/^.*extensions.https_everywhere._observatory.popup_shown.*/user_pref("extensions.https_everywhere._observatory.popup_shown", true);' "${file}" 2>/dev/null \
  || echo 'user_pref("extensions.https_everywhere._observatory.popup_shown", true);' >> "${file}"
sed -i 's/^.network.security.ports.banned.override/user_pref("network.security.ports.banned.override", "1-65455");' "${file}" 2>/dev/null \
  || echo 'user_pref("network.security.ports.banned.override", "1-65455");' >> "${file}"

#--- Replace bookmarks (base: http://pentest-bookmarks.googlecode.com)
file=$(find ~/.mozilla/firefox/*.default*/ -maxdepth 1 -type f -name 'bookmarks.html' -print -quit)
timeout 300 curl --progress -k -L -f "http://pentest-bookmarks.googlecode.com/files/bookmarksv1.5.html" > /tmp/bookmarks_new.html
#--- Configure bookmarks
awk '!a[$0]++' /tmp/bookmarks_new.html \
  | \egrep -v ">(Latest Headlines|Getting Started|Recently Bookmarked|Recent Tags|Mozilla Firefox|Help and Tutorials|Customize Firefox|Get Involved|About Us|Hacker Media|Bookmarks Toolbar|Most Visited)</" \
  | \egrep -v "^    </DL><p>" \
  | \egrep -v "^<DD>Add" > "${file}"
sed -i 's#^</DL><p>#        </DL><p>\n    </DL><p>\n</DL><p>#' "${file}"                                          # Fix import issues from pentest-bookmarks...
sed -i 's#^    <DL><p>#    <DL><p>\n    <DT><A HREF="http://127.0.0.1/">localhost</A>#' "${file}"                 # Add localhost to bookmark toolbar (before hackery folder)
sed -i 's#^</DL><p>#    <DT><A HREF="https://127.0.0.1:8834/">Nessus</A>\n</DL><p>#' "${file}"                    # Add Nessus UI bookmark toolbar
sed -i 's#^</DL><p>#    <DT><A HREF="http://127.0.0.1:3000/ui/panel">BeEF</A>\n</DL><p>#' "${file}"               # Add BeEF UI to bookmark toolbar
sed -i 's#^</DL><p>#    <DT><A HREF="http://127.0.0.1/rips/">RIPS</A>\n</DL><p>#' "${file}"                       # Add RIPs to bookmark toolbar
sed -i 's#^</DL><p>#    <DT><A HREF="https://paulschou.com/tools/xlate/">XLATE</A>\n</DL><p>#' "${file}"          # Add XLATE to bookmark toolbar
sed -i 's#^</DL><p>#    <DT><A HREF="https://hackvertor.co.uk/public">HackVertor</A>\n</DL><p>#' "${file}"        # Add HackVertor to bookmark toolbar
sed -i 's#^</DL><p>#    <DT><A HREF="http://www.irongeek.com/skiddypad.php">SkiddyPad</A>\n</DL><p>#' "${file}"   # Add Skiddypad to bookmark toolbar
sed -i 's#^</DL><p>#    <DT><A HREF="https://www.exploit-db.com/search/">Exploit-DB</A>\n</DL><p>#' "${file}"     # Add Exploit-DB to bookmark toolbar
sed -i 's#^</DL><p>#    <DT><A HREF="http://offset-db.com/">Offset-DB</A>\n</DL><p>#' "${file}"                   # Add Offset-DB to bookmark toolbar
sed -i 's#^</DL><p>#    <DT><A HREF="http://shell-storm.org/shellcode/">Shelcodes</A>\n</DL><p>#' "${file}"       # Add Shelcodes to bookmark toolbar
sed -i 's#^</DL><p>#    <DT><A HREF="http://ropshell.com/">ROP Shell</A>\n</DL><p>#' "${file}"                    # Add ROP Shell to bookmark toolbar
sed -i 's#^</DL><p>#    <DT><A HREF="https://ifconfig.io/">ifconfig</A>\n</DL><p>#' "${file}"                     # Add ifconfig.io to bookmark toolbar
sed -i 's#<HR>#<DT><H3 ADD_DATE="1303667175" LAST_MODIFIED="1303667175" PERSONAL_TOOLBAR_FOLDER="true">Bookmarks Toolbar</H3>\n<DD>Add bookmarks to this folder to see them displayed on the Bookmarks Toolbar#' "${file}"
#--- Clear bookmark cache
find ~/.mozilla/firefox/*.default*/ -maxdepth 1 -mindepth 1 -type f -name "places.sqlite" -delete
find ~/.mozilla/firefox/*.default*/bookmarkbackups/ -type f -delete
#--- Set firefox for XFCE's default
mkdir -p ~/.config/xfce4/
file=~/.config/xfce4/helpers.rc
sed -i 's#^WebBrowser=.*#WebBrowser=firefox#' "${file}" 2>/dev/null \
  || echo 'WebBrowser=firefox' >> "${file}"


##### Setup firefox's plugins
#--- Configure firefox
export DISPLAY=:0.0
#--- Download extensions
ffpath="$(find ~/.mozilla/firefox/*.default*/ -maxdepth 0 -mindepth 0 -type d -name '*.default*' -print -quit)/extensions"
mkdir -p "${ffpath}/"
#--- plug-n-hack
#curl --progress -k -L -f "https://github.com/mozmark/ringleader/blob/master/fx_pnh.xpi?raw=true????????????????"  \
#  || echo ' '${RED}'[!]'${RESET}" Issue downloading 'plug-n-hack' 1>&2
#--- HttpFox
#curl --progress -k -L -f "https://addons.mozilla.org/en-GB/firefox/addon/httpfox/??????????????"  \
#  || echo ' '${RED}'[!]'${RESET}" Issue downloading 'HttpFox' 1>&2
#--- SQLite Manager
timeout 300 curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/5817/addon-5817-latest.xpi?src=dp-btn-primary" \
  -o "${ffpath}/SQLiteManager@mrinalkant.blogspot.com.xpi"
#--- Cookies Manager+
timeout 300 curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/92079/addon-92079-latest.xpi?src=dp-btn-primary" \
  -o "${ffpath}/{bb6bc1bb-f824-4702-90cd-35e2fb24f25d}.xpi"
#--- Firebug
timeout 300 curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/1843/addon-1843-latest.xpi?src=dp-btn-primary" \
  -o "${ffpath}/firebug@software.joehewitt.com.xpi"
#--- FoxyProxy Basic
timeout 300 curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/15023/addon-15023-latest.xpi?src=dp-btn-primary" \
  -o "${ffpath}/foxyproxy-basic@eric.h.jung.xpi"
#--- User Agent Overrider
timeout 300 curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/429678/addon-429678-latest.xpi?src=dp-btn-primary" \
  -o "${ffpath}/useragentoverrider@qixinglu.com.xpi"
#--- HTTPS Everywhere
timeout 300 curl --progress -k -L -f "https://www.eff.org/files/https-everywhere-latest.xpi" \
  -o "${ffpath}/https-everywhere@eff.org.xpi"
#--- Live HTTP Headers
timeout 300 curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/3829/addon-3829-latest.xpi?src=dp-btn-primary" \
  -o "${ffpath}/{8f8fe09b-0bd3-4470-bc1b-8cad42b8203a}.xpi"
#---Tamper Data
timeout 300 curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/966/addon-966-latest.xpi?src=dp-btn-primary" \
  -o "${ffpath}/{9c51bd27-6ed8-4000-a2bf-36cb95c0c947}.xpi"
#--- Disable Add-on Compatibility Checks
timeout 300 curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/300254/addon-300254-latest.xpi?src=dp-btn-primary" \
  -o "${ffpath}/check-compatibility@dactyl.googlecode.com.xpi"
#--- Disable HackBar
timeout 300 curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/3899/addon-3899-latest.xpi?src=dp-btn-primary" \
  -o "${ffpath}/{F5DDF39C-9293-4d5e-9AA8-E04E6DD5E9B4}.xpi"
#--- uBlock
timeout 300 curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/607454/addon-607454-latest.xpi?src=dp-btn-primary" \
  -o "${ffpath}/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}.xpi"
#--- Installing extensions
for FILE in $(find "${ffpath}" -maxdepth 1 -type f -name '*.xpi'); do
  d="$(basename "${FILE}" .xpi)"
  mkdir -p "${ffpath}/${d}/"
  unzip -q -o -d "${ffpath}/${d}/" "${FILE}"
  rm -f "${FILE}"
done
#--- Enable Firefox's addons/plugins/extensions
timeout 15 firefox >/dev/null 2>&1
timeout 5 killall -9 -q -w firefox-esr >/dev/null
sleep 3s
#--- Method #1 (Works on older versions)
file=$(find ~/.mozilla/firefox/*.default*/ -maxdepth 1 -type f -name 'extensions.sqlite' -print -quit)   #&& [ -e "${file}" ] && cp -n $file{,.bkup}
apt -y -qq install sqlite3
rm -f /tmp/firefox.sql
touch /tmp/firefox.sql
echo "UPDATE 'main'.'addon' SET 'active' = 1, 'userDisabled' = 0;" > /tmp/firefox.sql    # Force them all!
sqlite3 "${file}" < /tmp/firefox.sql      #fuser extensions.sqlite
#--- Method #2 (Newer versions)
file=$(find ~/.mozilla/firefox/*.default*/ -maxdepth 1 -type f -name 'extensions.json' -print -quit)   #&& [ -e "${file}" ] && cp -n $file{,.bkup}
sed -i 's/"active":false,/"active":true,/g' "${file}"                # Force them all!
sed -i 's/"userDisabled":true,/"userDisabled":false,/g' "${file}"    # Force them all!
#--- Remove cache
file=$(find ~/.mozilla/firefox/*.default*/ -maxdepth 1 -type f -name 'prefs.js' -print -quit)   #&& [ -e "${file}" ] && cp -n $file{,.bkup}
[ -n "${file}" ] \
  && sed -i '/extensions.installCache/d' "${file}"
#--- For extensions that just work without restarting
timeout 15 firefox >/dev/null 2>&1
timeout 5 killall -9 -q -w firefox-esr >/dev/null
sleep 3s
#--- For (most) extensions, as they need firefox to restart
timeout 15 firefox >/dev/null 2>&1
timeout 5 killall -9 -q -w firefox-esr >/dev/null
sleep 5s
#--- Wipe session (due to force close)
find ~/.mozilla/firefox/*.default*/ -maxdepth 1 -type f -name 'sessionstore.*' -delete
#--- Configure foxyproxy
file=$(find ~/.mozilla/firefox/*.default*/ -maxdepth 1 -type f -name 'foxyproxy.xml' -print -quit)   #&& [ -e "${file}" ] && cp -n $file{,.bkup}
  echo '<?xml version="1.0" encoding="UTF-8"?>\n<foxyproxy mode="disabled" selectedTabIndex="0" toolbaricon="true" toolsMenu="true" contextMenu="false" advancedMenus="false" previousMode="disabled" resetIconColors="true" useStatusBarPrefix="true" excludePatternsFromCycling="false" excludeDisabledFromCycling="false" ignoreProxyScheme="false" apiDisabled="false" proxyForVersionCheck=""><random includeDirect="false" includeDisabled="false"/><statusbar icon="true" text="false" left="options" middle="cycle" right="contextmenu" width="0"/><toolbar left="options" middle="cycle" right="contextmenu"/><logg enabled="false" maxSize="500" noURLs="false" header="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;\n&lt;!DOCTYPE html PUBLIC &quot;-//W3C//DTD XHTML 1.0 Strict//EN&quot; &quot;http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd&quot;&gt;\n&lt;html xmlns=&quot;http://www.w3.org/1999/xhtml&quot;&gt;&lt;head&gt;&lt;title&gt;&lt;/title&gt;&lt;link rel=&quot;icon&quot; href=&quot;http://getfoxyproxy.org/favicon.ico&quot;/&gt;&lt;link rel=&quot;shortcut icon&quot; href=&quot;http://getfoxyproxy.org/favicon.ico&quot;/&gt;&lt;link rel=&quot;stylesheet&quot; href=&quot;http://getfoxyproxy.org/styles/log.css&quot; type=&quot;text/css&quot;/&gt;&lt;/head&gt;&lt;body&gt;&lt;table class=&quot;log-table&quot;&gt;&lt;thead&gt;&lt;tr&gt;&lt;td class=&quot;heading&quot;&gt;${timestamp-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${url-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${proxy-name-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${proxy-notes-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${pattern-name-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${pattern-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${pattern-case-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${pattern-type-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${pattern-color-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${pac-result-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${error-msg-heading}&lt;/td&gt;&lt;/tr&gt;&lt;/thead&gt;&lt;tfoot&gt;&lt;tr&gt;&lt;td/&gt;&lt;/tr&gt;&lt;/tfoot&gt;&lt;tbody&gt;" row="&lt;tr&gt;&lt;td class=&quot;timestamp&quot;&gt;${timestamp}&lt;/td&gt;&lt;td class=&quot;url&quot;&gt;&lt;a href=&quot;${url}&quot;&gt;${url}&lt;/a&gt;&lt;/td&gt;&lt;td class=&quot;proxy-name&quot;&gt;${proxy-name}&lt;/td&gt;&lt;td class=&quot;proxy-notes&quot;&gt;${proxy-notes}&lt;/td&gt;&lt;td class=&quot;pattern-name&quot;&gt;${pattern-name}&lt;/td&gt;&lt;td class=&quot;pattern&quot;&gt;${pattern}&lt;/td&gt;&lt;td class=&quot;pattern-case&quot;&gt;${pattern-case}&lt;/td&gt;&lt;td class=&quot;pattern-type&quot;&gt;${pattern-type}&lt;/td&gt;&lt;td class=&quot;pattern-color&quot;&gt;${pattern-color}&lt;/td&gt;&lt;td class=&quot;pac-result&quot;&gt;${pac-result}&lt;/td&gt;&lt;td class=&quot;error-msg&quot;&gt;${error-msg}&lt;/td&gt;&lt;/tr&gt;" footer="&lt;/tbody&gt;&lt;/table&gt;&lt;/body&gt;&lt;/html&gt;"/><warnings/><autoadd enabled="false" temp="false" reload="true" notify="true" notifyWhenCanceled="true" prompt="true"><match enabled="true" name="Dynamic AutoAdd Pattern" pattern="*://${3}${6}/*" isRegEx="false" isBlackList="false" isMultiLine="false" caseSensitive="false" fromSubscription="false"/><match enabled="true" name="" pattern="*You are not authorized to view this page*" isRegEx="false" isBlackList="false" isMultiLine="true" caseSensitive="false" fromSubscription="false"/></autoadd><quickadd enabled="false" temp="false" reload="true" notify="true" notifyWhenCanceled="true" prompt="true"><match enabled="true" name="Dynamic QuickAdd Pattern" pattern="*://${3}${6}/*" isRegEx="false" isBlackList="false" isMultiLine="false" caseSensitive="false" fromSubscription="false"/></quickadd><defaultPrefs origPrefetch="null"/><proxies>' > "${file}"
  echo '<proxy name="localhost:8080" id="1145138293" notes="e.g. Burp, w3af" fromSubscription="false" enabled="true" mode="manual" selectedTabIndex="0" lastresort="false" animatedIcons="true" includeInCycle="false" color="#07753E" proxyDNS="true" noInternalIPs="false" autoconfMode="pac" clearCacheBeforeUse="true" disableCache="true" clearCookiesBeforeUse="false" rejectCookies="false"><matches/><autoconf url="" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><autoconf url="http://wpad/wpad.dat" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><manualconf host="127.0.0.1" port="8080" socksversion="5" isSocks="false" username="" password="" domain=""/></proxy>' >> "${file}"
  echo '<proxy name="localhost:8081 (socket5)" id="212586674" notes="e.g. SSH" fromSubscription="false" enabled="true" mode="manual" selectedTabIndex="0" lastresort="false" animatedIcons="true" includeInCycle="false" color="#917504" proxyDNS="true" noInternalIPs="false" autoconfMode="pac" clearCacheBeforeUse="true" disableCache="true" clearCookiesBeforeUse="false" rejectCookies="false"><matches/><autoconf url="" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><autoconf url="http://wpad/wpad.dat" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><manualconf host="127.0.0.1" port="8081" socksversion="5" isSocks="true" username="" password="" domain=""/></proxy>' >> "${file}"
  echo '<proxy name="No Caching" id="3884644610" notes="" fromSubscription="false" enabled="true" mode="system" selectedTabIndex="0" lastresort="false" animatedIcons="true" includeInCycle="false" color="#990DA6" proxyDNS="true" noInternalIPs="false" autoconfMode="pac" clearCacheBeforeUse="true" disableCache="true" clearCookiesBeforeUse="false" rejectCookies="false"><matches/><autoconf url="" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><autoconf url="http://wpad/wpad.dat" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><manualconf host="" port="" socksversion="5" isSocks="false" username="" password="" domain=""/></proxy>' >> "${file}"
  echo '<proxy name="Default" id="3377581719" notes="" fromSubscription="false" enabled="true" mode="direct" selectedTabIndex="0" lastresort="true" animatedIcons="false" includeInCycle="true" color="#0055E5" proxyDNS="true" noInternalIPs="false" autoconfMode="pac" clearCacheBeforeUse="false" disableCache="false" clearCookiesBeforeUse="false" rejectCookies="false"><matches><match enabled="true" name="All" pattern="*" isRegEx="false" isBlackList="false" isMultiLine="false" caseSensitive="false" fromSubscription="false"/></matches><autoconf url="" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><autoconf url="http://wpad/wpad.dat" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><manualconf host="" port="" socksversion="5" isSocks="false" username="" password=""/></proxy>' >> "${file}"
  echo '</proxies></foxyproxy>' >> "${file}"
