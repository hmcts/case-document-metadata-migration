#!/bin/bash

mkdir -p tmp
POSTMASTER=/usr/local/var/postgres/postmaster.pid
if [ ! -f "$POSTMASTER" ]; then
    echo -n "[*] Starting local postgres server... "
    pg_ctl -D /usr/local/var/postgres -l tmp/pg.log start 2>&1 > /dev/null
    echo "[done]"
fi
