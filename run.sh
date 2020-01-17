#!/usr/bin/env bash
set +u

CONFIG=/data/options.json

SERVER="$(jq --raw-output '.server' $CONFIG)"
USERNAME="$(jq --raw-output '.username' $CONFIG)"
PASSWORD="$(jq --raw-output '.password' $CONFIG)"
TUNNEL="vpn"

#if [ ! -f /dev/ppp ]; then
#  mknod /dev/ppp c 108 0
#fi

cat > /etc/ppp/peers/${TUNNEL} <<_EOF_
pty "pptp ${SERVER} --nolaunchpppd"
name "${USERNAME}" #логин
password "${PASSWORD}"
remotename PPTP #имя соединения
require-mppe-128 #включаем поддержку MPPE
require-mschap-v2
persist #переподключаться при обрыве
maxfail 10 #количество попыток переподключения
holdoff 15 #интервал между подключениями
file /etc/ppp/options.pptp
_EOF_

cat > /etc/ppp/ip-up <<"_EOF_"
#!/bin/sh
ip route add 0.0.0.0/1 dev $1
ip route add 128.0.0.0/1 dev $1
_EOF_

cat > /etc/ppp/ip-down <<"_EOF_"
#!/bin/sh
ip route del 0.0.0.0/1 dev $1
ip route del 128.0.0.0/1 dev $1
_EOF_

exec pon ${TUNNEL} debug dump logfd 2 nodetach "$@"