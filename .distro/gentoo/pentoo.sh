
#  Start Networking
rc-service NetworkManager start

# or if using systemctl/general approach depending on your exact session:
sudo systemctl start NetworkManager

# To connect to WIFi
nmcli device wifi connect "SSID_NAME" password "YOUR_PASSWORD"

#  Start Networking via Gentoo Netifrc (OpenRC)
ip link
sudo rc-service net.enp8s0 start
