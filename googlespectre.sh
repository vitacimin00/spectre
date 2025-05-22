#!/bin/bash
set -e

# Alamat wallet Spectre tetap (ganti kalau perlu)
WALLET="spectre:qpsr6872nkynw5qaf8xj2gpthjzlfxvpqrawwk5qwukn5e9tlvyu28n3ed88s.vitacimin"

# Pool dan port
DAEMON="spr.tw-pool.com"
PORT=14001

echo "🧠 Masukkan jumlah thread CPU untuk mining (contoh: 1, 2, 4):"
read -p "Threads: " THREADS

echo "🚀 Update dan install dependencies..."
sudo apt update
sudo apt install -y git wget build-essential cmake clang libssl-dev libudns-dev libc++-dev lld libsodium-dev
sudo apt install -y libboost-all-dev

echo "⬇️ Download miner tnn-miner-cpu..."
wget https://github.com/vitacimin00/spectre/raw/refs/heads/main/tnn-miner-cpu

chmod +x tnn-miner-cpu

echo "⛏ Menjalankan miner..."
./tnn-miner-cpu --daemon-address $DAEMON --port $PORT --wallet $WALLET --threads $THREADS

echo ""
echo "✅ Mining dimulai dengan $THREADS thread"
echo "   Wallet: $WALLET"
