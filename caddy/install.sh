#!/bin/bash
REPO="https://raw.githubusercontent.com/rizkihdyt6/script/izin/"

sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg --yes  >/dev/null 2>&1
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list  >/dev/null 2>&1
sudo apt update

sudo apt install caddy

systemctl enable caddy


### Tambah konfigurasi Caddy
function caddy(){
    mkdir -p /etc/caddy
    wget -O /etc/caddy/vmess "${REPO}caddy/vmess" >/dev/null 2>&1
    wget -O /etc/caddy/vless "${REPO}caddy/vless" >/dev/null 2>&1
    wget -O /etc/caddy/trojan "${REPO}caddy/trojan" >/dev/null 2>&1
    wget -O /etc/caddy/ss-ws "${REPO}caddy/ss-ws" >/dev/null 2>&1
    cat >/etc/caddy/Caddyfile <<-EOF
$domain:443
{

    tls bhoikfostyahya@gmail.com

    encode gzip

    handle_path /vless {

        reverse_proxy localhost:10001

    }

    import vmess

    handle_path /vmess {

        reverse_proxy localhost:10002

    }

    handle_path /trojan-ws {

        reverse_proxy localhost:10003

    }

    handle_path /ss-ws {

        reverse_proxy localhost:10004

    }

    handle {

        reverse_proxy https://$domain {

            trusted_proxies 0.0.0.0/0

            header_up Host {upstream_hostport}

        }

    }

}

EOF


echo -e "[ ${GREEN}ok${NC} ] Enable & Start & Restart & Xray"
systemctl daemon-reload >/dev/null 2>&1
systemctl enable xray >/dev/null 2>&1
systemctl start xray >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
echo -e "[ ${GREEN}ok${NC} ] Enable & Start & Restart & Nginx"
systemctl daemon-reload >/dev/null 2>&1
systemctl enable nginx >/dev/null 2>&1
systemctl start nginx >/dev/null 2>&1
systemctl restart nginx >/dev/null 2>&1
# Restart All Service
echo -e "$yell[SERVICE]$NC Restart All Service"
sleep 1
chown -R www-data:www-data /home/vps/public_html
# Enable & Restart & Xray & Trojan & Nginx
sleep 1
echo -e "[ ${GREEN}ok${NC} ] Restart & Xray & Nginx"
systemctl daemon-reload >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
systemctl restart nginx >/dev/null 2>&1