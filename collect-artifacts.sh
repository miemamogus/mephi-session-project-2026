#!/bin/bash
set -eu
cd /root/mephi-session-project-2026
ping -c 4 8.8.8.8 > ping.out
stat /data/mephi-2026 > stat.out
stat /mephi-web >> stat.out
getcap /usr/sbin/tcpdump > getcap.out
dnf history > dnf.out
journalctl -u nginx -b --no-pager > journalctl.out
getenforce > getenforce.out
curl --fail http://localhost/ > curl.out
lsblk -o NAME,SIZE,TYPE,FSTYPE,LABEL,MOUNTPOINTS > lsblk.out
findmnt /mephi-web > mount.out
getfacl /data/mephi-2026 > acl.out
cp /etc/passwd /etc/group /etc/fstab /etc/login.defs /etc/nginx/nginx.conf .
cp /etc/security/pwquality.conf.d/99-mephi.conf pwquality.conf
cp /etc/pam.d/login pam-login
cp /etc/security/mephi-console.access .
cp /etc/selinux/config selinux-config
cp /etc/selinux/targeted/contexts/files/file_contexts.local .
cp /etc/systemd/system/nginx.service.d/mephi-mount.conf .
awk -F: 'BEGIN{OFS=":"} {$2=($2=="!" || $2=="!!" || $2=="*" ? $2 : "REDACTED");print}' /etc/shadow > shadow
{ hostnamectl; systemctl get-default; systemctl is-enabled nginx; systemctl is-active nginx; getenforce; findmnt /mephi-web; curl --fail http://localhost/; } > reboot-check.out
cp /root/finish-project.sh .
