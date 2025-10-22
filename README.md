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
