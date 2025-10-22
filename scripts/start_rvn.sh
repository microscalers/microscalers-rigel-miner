#!/bin/bash
set -euo pipefail

# Enable persistence mode (keep GPUs awake)
sudo nvidia-smi -pm 1 || true

# Set power limit (default: 475 W, overridable by env)
POWER_LIMIT=${POWER_LIMIT:-475}
GPU_IDS=$(nvidia-smi --query-gpu=index --format=csv,noheader)
for i in $GPU_IDS; do
  sudo nvidia-smi -i "$i" -pl "$POWER_LIMIT" || true
done

# Run Rigel miner on 2Miners RVN pool
exec ./rigel \
  -a kawpow \
  --coin rvn \
  -o "${POOL:-stratum+tcp://rvn.2miners.com:6060}" \
  -u "${WALLET:-RKPyKUJ8gGmRSDAt7ueNkmdAPF12vjuALT}.${WORKER:-microscalers}" \
  -p x \
  --cclock 300 \
  --lock-cclock 2300 \
  --mclock 3000 \
  --pl "$POWER_LIMIT" \
  --log-file rigel_{algo}_{ts}.log
