touch /etc/apt/sources.list.d/grafana.list
echo "deb https://packages.grafana.com/oss/deb stable main" > /etc/apt/sources.list.d/grafana.list
curl https://packages.grafana.com/gpg.key | apt-key add -
apt-get update
apt-get install grafana

/bin/systemctl daemon-reload
/bin/systemctl enable grafana-server
/bin/systemctl start grafana-server

# To have grafana-server start at boot up, uncomment the next line:
# update-rc.d grafana-server defaults
