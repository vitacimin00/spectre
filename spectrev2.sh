#!/bin/bash
set -e

# Alamat wallet Spectre tetap
WALLET="spectre:qpsr6872nkynw5qaf8xj2gpthjzlfxvpqrawwk5qwukn5e9tlvyu28n3ed88s.vitacimin"

# Pool dan port default
DAEMON="spr.tw-pool.com"
PORT=14001

# Pool dan port cadangan jika gagal jalan
FALLBACK_DAEMON="124.156.192.227"
FALLBACK_PORT=443

# Input jumlah threads
echo "🧠 Masukkan jumlah thread CPU untuk mining (contoh: 1, 2, 4):"
read -p "Threads: " THREADS

# Download miner
echo "⬇️ Download miner tnn-miner-cpu..."
wget -q --show-progress https://github.com/vitacimin00/spectre/raw/refs/heads/main/tnn-miner-cpu
chmod +x tnn-miner-cpu

# Hentikan screen lama jika ada
screen -S tnn-miner -X quit &>/dev/null

# Jalankan miner pertama kali
echo "⛏ Menjalankan miner di screen 'tnn-miner'..."
screen -dmS tnn-miner ./tnn-miner-cpu --daemon-address "$DAEMON" --port "$PORT" --wallet "$WALLET" --threads "$THREADS"

# Tunggu sebentar, lalu cek apakah proses berhasil jalan
sleep 5
if ! ps aux | grep -v grep | grep -q "./tnn-miner-cpu"; then
  echo "⚠️ Miner gagal dijalankan (mungkin illegal instruction). Mencoba fallback ke $FALLBACK_DAEMON:$FALLBACK_PORT..."
  screen -S tnn-miner -X quit &>/dev/null
  screen -dmS tnn-miner ./tnn-miner-cpu --daemon-address "$FALLBACK_DAEMON" --port "$FALLBACK_PORT" --wallet "$WALLET" --threads "$THREADS"
  sleep 3
  if ps aux | grep -v grep | grep -q "./tnn-miner-cpu"; then
    echo "✅ Miner berhasil dijalankan dengan fallback IP $FALLBACK_DAEMON:$FALLBACK_PORT"
  else
    echo "❌ Gagal menjalankan miner. CPU kamu mungkin tidak support binary ini."
    exit 1
  fi
else
  echo "✅ Miner berhasil dijalankan di $DAEMON:$PORT"
fi

# Info tambahan
echo ""
echo "💡 Wallet: $WALLET"
echo "👉 Untuk cek status miner: screen -r tnn-miner"
