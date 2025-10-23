#!/bin/bash
set -euo pipefail

HOSTNAME=$(hostname)
GPU_IDS=$(nvidia-smi --query-gpu=index --format=csv,noheader)

sudo nvidia-smi -pm 1
for i in $GPU_IDS; do
  sudo nvidia-smi -i "$i" -pl 475 || true
done

WALLET="RKPyKUJ8gGmRSDAt7ueNkmdAPF12vjuALT"
POOL="stratum+tcp://rvn.2miners.com:6060"
WORKER="${HOSTNAME}"

exec ./rigel \
  -a kawpow \
  --coin rvn \
  -o ${POOL} \
  -u ${WALLET}.${WORKER} \
  -p x \
  --cclock 300 \
  --mclock 2000 \
  --pl 475 \
  --temp-limit "tc[60-70]tm[100-110]" \
  --log-file rigel_${HOSTNAME}_{ts}.log
