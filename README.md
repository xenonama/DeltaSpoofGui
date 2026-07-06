# 🛡️ DeltaSpoofGui

**یک ابزار قدرتمند و چندسکویی برای عبور از سانسور (DPI Bypass) با رابط کاربری گرافیکی مدرن**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)](https://python.org)

## ✨ ویژگی‌ها

- 🛡️ **عبور از DPI** با استفاده از جعل SNI و چرخش هوشمند آی‌پی
- 🖥️ **رابط کاربری مدرن** با Electron و TypeScript
- 📋 **مدیریت SNI** با دو لیست مجزا (اصلی/انتخابی)
- 📡 **پینگر** تست زنده بودن SNIها با نمایش کیفیت
- 📊 **داشبورد** با آمار لحظه‌ای و جدول اتصالات
- ⚙️ **تنظیمات کامل** با حالت‌های auto_spoof، find_ip، sni_spoof
- 📜 **لاگ جمع‌شونده** با قابلیت کپی
- 🔄 **چرخه auto_spoof** برای بهینه‌سازی خودکار

## 🚀 نصب و اجرا

### روش ۱: استفاده از فایل اجرایی (ساده‌ترین)
1. فایل `DeltaSpoofGui.exe` را از [Releases](https://github.com/xenonama/DeltaSpoofGui/releases) دانلود کنید.
2. 2. فایل را اجرا کنید. (مرورگر به‌طور خودکار باز می‌شود)

### روش ۲: اجرا از سورس کد
```bash
git clone https://github.com/your-username/DeltaSpoofGui.git
cd DeltaSpoofGui
pip install -r backend/requirements.txt
python run.py
