# Microscalers Rigel Miner

Terminal-grade setup for running the **Rigel GPU miner** on Microscaler rigs.  
Supports **NVIDIA RTX 5090 / 5080 series**, tuned for **Ravencoin (Kawpow)**, and compatible with **systemd**, **Docker**, and **K3s node orchestration**.

⚡ Quick Start

```bash
git clone git@github.com:microscalers/microscalers-rigel-miner.git
cd microscalers-rigel-miner/scripts
chmod +x start_rvn.sh
sudo ./start_rvn.sh
sudo cp ../systemd/rigel-rvn.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable rigel-rvn.service
sudo systemctl start rigel-rvn.service

microscalers-rigel-miner/
├── README.md
├── LICENSE
├── .gitignore
├── scripts/
│   ├── start_rvn.sh
│   ├── install_rigel.sh
│   └── update_rigel.sh
├── systemd/
│   └── rigel-rvn.service
├── docker/
│   ├── Dockerfile
│   └── docker-compose.yml
└── examples/
    └── config.env.example


---

### 2️⃣ Add the miner start script
```bash
cat > scripts/start_rvn.sh <<'EOF'
#!/bin/bash
set -euo pipefail

sudo nvidia-smi -pm 1
for i in $(nvidia-smi --query-gpu=index --format=csv,noheader); do
  sudo nvidia-smi -i "$i" -pl 475 || true
done

exec ./rigel \
  -a kawpow \
  --coin rvn \
  -o stratum+tcp://rvn.2miners.com:6060 \
  -u RKPyKUJ8gGmRSDAt7ueNkmdAPF12vjuALT.microscalers \
  -p x \
  --cclock 300 \
  --lock-cclock 2300 \
  --mclock 3000 \
  --pl 475 \
  --log-file rigel_{algo}_{ts}.log
# 🦾 Microscalers Rigel Miner

**Microscalers Rigel Miner** is a production-grade containerized miner built for high-performance GPU rigs.  
It’s fully compatible with NVIDIA RTX 50xx GPUs, runs on Ubuntu 24.04+, and auto-boots via `systemd` or Docker.

---

## ⚙️ Features
- 🔒 Rootless secure container with non-root `miner` user  
- 🧩 One-command deployment via Docker Compose  
- ⚡ Tuned for 5090 GPUs and 2Miners `kawpow` (Ravencoin)  
- 📜 Auto-logging to `/opt/rigel/logs` inside container  
- 🧠 Designed for Kubernetes, Proxmox, or bare-metal rigs  

---

## 🐳 Quick Deploy (Docker)
Clone the repo and start mining instantly:

```bash
git clone https://github.com/microscalers/microscalers-rigel-miner.git
cd microscalers-rigel-miner
sudo docker compose up -d --build
sudo docker logs -f rigel-miner
| Variable      | Description              | Default                              |
| ------------- | ------------------------ | ------------------------------------ |
| `GPU_ID`      | GPU index to use         | `0`                                  |
| `POOL`        | Mining pool URL          | `stratum+tcp://rvn.2miners.com:6060` |
| `WALLET`      | Ravencoin wallet address | `RKPyKUJ8gGmRSDAt7ueNkmdAPF12vjuALT` |
| `WORKER`      | Worker name              | `microscalers`                       |
| `POWER_LIMIT` | GPU power limit (W)      | `475`                                |
sudo cp systemd/rigel-rvn.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now rigel-rvn.service
🛠️ Hardware Recommended

Ubuntu 24.04 LTS

NVIDIA RTX 5090 / 5080 GPUs

CUDA 13.0 / Driver 580+

64GB DDR5, Ryzen 7950X or better

Fiber network, static IP for remote orchestration🐈 Credits

Built by Microscalers Compute Labs
for TrustCat.ai / MineChain GPU Micro-Hub Fleet 🧠💰
MIT License – Feel free to fork, extend, and scale.
