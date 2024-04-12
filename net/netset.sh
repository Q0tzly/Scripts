#! /bin/sh

while true; do
  echo "select mode (eduroam(e) or nomal(n), quit(q)):"
  read mode

  if [ "$mode" = "q" ]; then
    echo "quit"
    exit 0

  elif [ "$mode" = "n" ]; then
    echo "nomal setting."
    echo "ssid:"
    read ssid
    echo "password"
    read password

    data="network={
      ssid=\"$ssid\"
      psk=\"$password\"
    }"

    break
  elif [ "$mode" = "e" ]; then
    echo "eduroam's setting."
    echo "user id:"
    read id
    echo "password:"
    read password

    data="network={
      ssid=\"eduroam\"
      key_mgmt=WPA-EAP
      eap=PEAP
      identity=\"$id\"
      password=\"$password\"
      phase1=\"peaplabel=0\"
      phase2=\"auth=MSCHAPV2\"
    }"

    break
  else
    echo "write right char."
  fi
done

while true; do
  echo "select device [lan(l) or wifi(w), quit(q)]"
  read device
  if [ "$device" = "q" ]; then
    echo "quit"
    exit 0
  elif [ "$device" = "l" ]; then
    device=lan0    
    break
  elif [ "$device" = "w" ]; then
    device=wlan0
    break
  else
    echo "write right char."
  fi
done

echo ""
echo "$data"
echo ""

while true; do  
  echo "can I make and write to '/etc/wpa_supplicant/wpa_supplicant.conf' (y or q(quit))"
  read select
  if [ "$select" = "q" ]; then
    echo "quit"
    exit 0
  elif [ "$select" = "y" ]; then
    echo "$data" > /etc/wpa_supplicant/wpa_supplicant.conf
    break
  else
    echo "write right char."
  fi
done

echo ""
echo "$device"
echo ""

sudo wpa_supplicant -B -c /etc/wpa_supplicant/wpa_supplicant.conf -i $device
sudo dhclient $device
