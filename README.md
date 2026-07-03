# DeltaSpoof

> **Cross-platform DPI bypass proxy** — forked from [nullroute1970/ZeroDPI](https://github.com/nullroute1970/ZeroDPI)

DeltaSpoof sits between your **upstream VPN app** (xray-core, sing-box, v2ray, etc.) and the internet, transparently evading **Deep Packet Inspection (DPI)** that would otherwise block or throttle your VPN traffic.

It works on **Windows**, **Linux**, **Android/Termux**.

---

## Download

| Platform | File | Format |
|----------|------|--------|
| **Windows x86_64** | [deltaspoof-windows-x86_64.zip](https://github.com/Delta-Kronecker/DeltaSpoof/releases/download/v0.1.13/deltaspoof-windows-x86_64.zip) | zip |
| **Linux x86_64** | [deltaspoof-linux-x86_64.tar.gz](https://github.com/Delta-Kronecker/DeltaSpoof/releases/download/v0.1.13/deltaspoof-linux-x86_64.tar.gz) | tar.gz |
| **Termux (Android aarch64)** | [deltaspoof-termux-aarch64.tar.gz](https://github.com/Delta-Kronecker/DeltaSpoof/releases/download/v0.1.13/deltaspoof-termux-aarch64.tar.gz) | tar.gz |

Each archive includes: binary + `config.toml` + `sni_list.txt` + `ip_list.txt`

---

## Quick Start

1. Download and extract the archive for your platform
2. Edit `config.toml` — set `MODE = "auto_spoof"` (or `find_ip`)
3. Run:

```powershell
# Windows
.\deltaspoof.exe

# Linux
chmod +x deltaspoof
./deltaspoof

# Termux
chmod +x deltaspoof
./deltaspoof
```

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
| `find_ip` | Single-domain: SNI scan → domain → IP range → live proxy |
| **`auto_spoof`** | **Multi-domain: each IP serves ALL domains simultaneously** |

---

## auto_spoof Mode

The main mode. Multiple domains are served simultaneously across a pool of IPs.

- **`www.hcaptcha.com` is always included** as the first domain
- Remaining domains are auto-selected from scan results (unique, highest score)
- `www.hcaptcha.com` is never duplicated

### How It Works

1. **SNI Scan** — Scans hostnames, auto-selects `www.hcaptcha.com` + top unique domains
2. **IP Range Selection** — User picks CIDR from `ip_list.txt`
3. **IP Scan** — Tests IPs in the range
4. **Live Proxy** — `MAX_IP × MAX_DOMAIN` connections, unified round-robin
5. **Cycle Evaluation** — Every `AUTO_SPOOF_CYCLE_SECS` seconds:
   - Evaluates per-(domain, IP) pair download bytes
   - Drops `AUTO_SPOOF_DROP_COUNT` weakest pairs
   - Replaces with scanned candidates
   - Resets all counters for new cycle
6. **Pin** — Press `s` to pin a connection (cycle manager stops)
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

Press `s` to see ALL (domain, IP) pairs ever used, sorted by Total. Pinning stops the cycle manager — the pinned IP stays.

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
MAX_IP = 10                 # IPs in pool
IP_TEST_TIMEOUT_SECS = 10   # cycle interval
FIND_IP_DROP_COUNT = 5      # IPs to drop per cycle
FIND_IP_MIN_BYTES = 1024    # min bytes to keep IP

# --- auto_spoof mode ---
MAX_DOMAIN = 5              # domains served simultaneously
MAX_IP_AUTO_SPOOF = 10      # IPs in pool
AUTO_SPOOF_CYCLE_SECS = 10  # cycle interval
AUTO_SPOOF_DROP_COUNT = 30  # pairs to drop per cycle
AUTO_SPOOF_MIN_BYTES = 1024 # min bytes to keep IP

# General
SCAN_TIMEOUT_SECS = 5
LISTEN_HOST = "127.0.0.1"
LISTEN_PORT = 40443
SELECTED_SNI = ""           # skip SNI scan if set
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
