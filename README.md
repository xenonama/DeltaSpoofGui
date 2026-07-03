# DeltaSpoof

> **Cross-platform DPI bypass proxy** — forked from [nullroute1970/ZeroDPI](https://github.com/nullroute1970/ZeroDPI)

DeltaSpoof sits between your **upstream VPN app** (xray-core, sing-box, v2ray, etc.) and the internet, transparently evading **Deep Packet Inspection (DPI)** that would otherwise block or throttle your VPN traffic.

It works on **Windows**, **Linux**, **Android/Termux**.

---

## Operating Modes

| Mode | Description |
|------|-------------|
| `sni_spoof` | DPI bypass via SNI spoofing (default ZeroDPI mode) |
| `ip_bypass` | Plain TCP relay through a scanned IP |
| `ip_bypass_plus` | IPv4 relay with real-SNI-preserving bypass method |
| `sni_scan` | Scan sni_list.txt and display results, then exit |
| `ip_scan` | Scan ip_list.txt and display results, then exit |
| `proxy_scan` | Test each working SNI through your V2RayN SOCKS5 port |
| `find_ip` | Full workflow: SNI scan → domain → IP range → live proxy with dynamic pool |
| **`auto_spoof`** | **Multi-domain live proxy: each IP serves ALL domains simultaneously** |

---

## auto_spoof Mode (New)

The main new feature. Instead of a single domain, DeltaSpoof serves **multiple domains simultaneously** across a pool of IPs.

### How It Works

1. **SNI Scan** — Scans candidate hostnames, auto-selects top `MAX_DOMAIN` domains
2. **Select IP Range** — User picks a CIDR range from `ip_list.txt`
3. **IP Scan** — Tests all IPs in the range
4. **Live Proxy** — Creates `MAX_IP × MAX_DOMAIN` connections, distributes traffic via unified round-robin
5. **Cycle Evaluation** — Every `AUTO_SPOOF_CYCLE_SECS` seconds:
   - Evaluates each (domain, IP) pair's download bytes
   - Removes the `AUTO_SPOOF_DROP_COUNT` weakest pairs
   - Replaces with scanned candidates from background scan
6. **Pin Connection** — Press `s` to pin a specific (domain, IP) combination
7. **Change Range** — Press `r` to change IP range

### Dashboard

```
┌ DeltaSpoof — AutoSpoof Dashboard ──────────────────────────────────┐
│Mode: auto_spoof   Domains: 5   IPs: 10   Connections: 50          │
├────────────────────────────────────────────────────────────────────┤
│Connection (domain:IP)           ↑/Cycle   ↓/Cycle   Total  Conns  │
│www.hcaptcha.com:104.16.0.1      4.7K/C    17K/C     12K    3      │
│cdnjs.com:104.16.0.1             4.6K/C    18K/C     12K    3      │
│...                                                                 │
└────────────────────────────────────────────────────────────────────┘
s pin   r change range   q/Esc quit
```

### Pin Connection Menu

Press `s` to see ALL (domain, IP) pairs ever used, sorted by Total:

```
┌ AutoSpoof — Pin Connection ────────────────────────────────────────┐
│Select a connection to pin (50 options, sorted by total)           │
├───────────────────────────────────────────────────────────────────┤
│Connection (domain:IP)           ↑/Cycle   ↓/Cycle   Total  Conns │
│www.hcaptcha.com:104.16.0.1      4.7K/C    17K/C     12K    3    │
│cdnjs.com:104.16.0.1             4.6K/C    18K/C     12K    3    │
│...                                                                │
└───────────────────────────────────────────────────────────────────┘
```

---

## find_ip Mode

Single-domain workflow: SNI scan → select domain → select IP range → test IPs → live proxy.

### Dashboard

```
┌ DeltaSpoof — Find IP Dashboard ────────────────────────────────────┐
│Mode: find_ip   SNI: www.hcaptcha.com                              │
│Max IPs: 10   Active: 10   Uptime: 25s                             │
├────────────────────────────────────────────────────────────────────┤
│IP Address        ↑/Cycle   ↓/Cycle   Total   Conns  Cycles  Dur  │
│104.16.0.1        4.7K/C    17K/C     12K     5      2       25s  │
│...                                                                 │
└────────────────────────────────────────────────────────────────────┘
s stop & pick   d change domain   r change IP range   q/Esc quit
```

---

## Configuration

```toml
# Mode selection
MODE = "auto_spoof"        # or "find_ip", "sni_spoof", etc.

# --- find_ip mode ---
MAX_IP = 10
IP_TEST_TIMEOUT_SECS = 10
FIND_IP_DROP_COUNT = 5
FIND_IP_MIN_BYTES = 1024

# --- auto_spoof mode ---
MAX_DOMAIN = 5
MAX_IP_AUTO_SPOOF = 10
AUTO_SPOOF_CYCLE_SECS = 10
AUTO_SPOOF_DROP_COUNT = 30    # pairs to drop per cycle
AUTO_SPOOF_MIN_BYTES = 1024

# General
SCAN_TIMEOUT_SECS = 5
LISTEN_HOST = "127.0.0.1"
LISTEN_PORT = 40443
SELECTED_SNI = ""             # skip SNI scan if set
```

---

## Quick Start

1. **Edit `config.toml`** — Set `MODE = "auto_spoof"` (or `find_ip`)
2. **Fill `sni_list.txt`** with CDN hostnames
3. **Fill `ip_list.txt`** with CIDR ranges
4. **Run:**
```powershell
# Windows
.\deltaspoof.exe --config .\config.toml

# Linux
sudo ./deltaspoof --config ./config.toml

# Termux
chmod +x deltaspoof-termux-aarch64
./deltaspoof-termux-aarch64 --config ./config.toml
```

---

## Building from Source

Requires **Rust 1.75+**.

```bash
# Linux
cargo build --release

# Windows (MSYS2 + GNU toolchain)
cargo +stable-x86_64-pc-windows-gnu build --workspace --release

# Termux (cross-compile with zig)
cargo zigbuild --workspace --release --target aarch64-unknown-linux-musl
```

---

## Credits

- Original project: [nullroute1970/ZeroDPI](https://github.com/nullroute1970/ZeroDPI)
- DPI bypass research: [patterniha/SNI-Spoofing](https://github.com/patterniha/SNI-Spoofing)

## License

MIT — see [LICENSE](LICENSE).
