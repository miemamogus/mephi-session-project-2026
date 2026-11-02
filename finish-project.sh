#!/bin/bash
set -euo pipefail
exec > >(tee -a /root/mephi-session-project-2026/setup.log) 2>&1
set -x
dnf install -y nginx libcap-ng-utils dnf-plugins-core acl policycoreutils-python-utils pamtester
dnf download --arch=x86_64 --destdir=/tmp tcpdump
rpm -Uvh --replacepkgs /tmp/tcpdump-*.x86_64.rpm
chmod u-s /usr/sbin/tcpdump
setcap cap_net_raw,cap_net_admin=ep /usr/sbin/tcpdump
sed -i 's@root         /usr/share/nginx/html;@root         /mephi-web;@' /etc/nginx/nginx.conf
printf 'Hello from Student: М265894\n' > /mephi-web/index.html
chmod 755 /mephi-web
chmod 644 /mephi-web/index.html
semanage fcontext -a -t httpd_sys_content_t '/mephi-web(/.*)?'
restorecon -Rv /mephi-web
mkdir -p /etc/systemd/system/nginx.service.d
printf '[Unit]\nRequiresMountsFor=/mephi-web\n' > /etc/systemd/system/nginx.service.d/mephi-mount.conf
systemctl daemon-reload
nginx -t
systemctl enable --now nginx
systemctl restart nginx
curl --fail http://localhost/
sudo -u user1 timeout 15 tcpdump -i lo -p -nn -c 2 icmp > /root/mephi-session-project-2026/tcpdump-test.out 2>&1 &
capture_pid=$!
sleep 1
ping -c 2 127.0.0.1
wait "$capture_pid"
getcap /usr/sbin/tcpdump
pamtester login user1 acct_mgmt
if pamtester login curator1 acct_mgmt; then echo 'ERROR: curator console access permitted'; exit 1; fi
pamtester sshd curator1 acct_mgmt
dnf history > /root/mephi-session-project-2026/dnf.out
set +x
