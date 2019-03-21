#!/bin/sh
/usr/sbin/sshd -D &

if [ ! -d /ostree ]; then
    mkdir /ostree
fi

if [ ! -d /ostree/repo ]; then
    cd /ostree
    ostree init --repo=repo --mode archive-z2
fi
cd /ostree/repo
python3 -m http.server 8000

