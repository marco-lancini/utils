SSID="WiFi_SSID"
SSID_PASS="WiFi_PWD"

# libqrencode on alpine
qrencode -t PNG -o wifi.png "WIFI:S:${SSID};T:WPA2;P:${SSID_PASS};;"
