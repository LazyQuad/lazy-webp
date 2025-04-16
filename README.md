# lazy-webp (v1.1.0)

**lazy-webp** is a dual-mode WebP conversion tool by [LazyQuad](https://github.com/LazyQuad)  
designed for converting PNG and JPG images into optimized `.webp` format for SEO and performance.

Use it interactively, in batch mode, or automate it with flags — on Windows or Unix-like systems.

---

## 🔧 Features

- 🖼️ Convert `.jpg`, `.jpeg`, `.png` images to `.webp`
- 🔁 Batch rename or manually name each file
- ⚙️ Adjustable quality settings
- 🚫 Optionally strip metadata
- 📁 Auto-create output directories
- 🧠 Manual mode supports typing `QUIT` to exit early
- 💻 Dual support for:
  - Windows CMD via `.bat`
  - macOS/Linux via Bash

---

## 📦 Folder Structure

```
lazy-webp/
├── lazy-webp.bat            ← Launcher for Windows users (detects WSL)
├── basic-convert.bat        ← Basic Windows batch converter
├── advanced-convert.sh      ← Advanced Bash script for Linux/macOS/WSL
├── cwebp/                   ← Drop cwebp.exe here (or use system PATH)
├── README.md                ← This file
```

---

## 🚀 Usage (Windows)

### 🖱️ Interactive Mode

1. Drop your `.png` or `.jpg` images into a folder
2. Place `cwebp.exe` in `lazy-webp/cwebp/` (or add it to PATH)
3. Run:
   - `basic-convert.bat` — for simplified conversion
   - `lazy-webp.bat` — to choose between Bash or Batch if WSL is installed

---

## 🐧 On macOS or Linux

1. Install `cwebp`:
   ```bash
   # Debian/Ubuntu
   sudo apt install webp

   # macOS (with Homebrew)
   brew install webp
   ```

2. Unzip or clone the `lazy-webp` folder.

3. Make the script executable:
   ```bash
   chmod +x advanced-convert.sh
   ```

4. Run it:
   ```bash
   ./advanced-convert.sh
   ```

5. Or use CLI flags:
   ```bash
   ./advanced-convert.sh --mode batch --base my-image --quality 85 --out ./output --strip-meta
   ```

> ⚠️ This script requires **Bash**.  
> If your system uses `sh` by default, run with `bash advanced-convert.sh`

---

## 🆕 What's New in v1.1.0

- Cleaned up prompts (fixed formatting + removed colon errors)
- Batch rename now works reliably (no overwrite bugs)
- Manual rename supports typing `QUIT` to exit early
- Auto-creates output directory if it doesn't exist
- Improved Bash version with flag support and manual fallback
- Added macOS/Linux installation instructions

---

## 💡 Tips

- In **manual mode**, type `QUIT` anytime to stop processing
- Use `Ctrl+C` before the loop starts (during pause) to cancel cleanly
- Bash script supports flags like `--quality`, `--out`, `--base`, `--strip-meta`

---

## ⚙️ Requirements

- Windows 10/11 (CMD or PowerShell) or
- macOS / Linux with Bash 4+
- `cwebp` installed, or `cwebp.exe` dropped into `/cwebp/`

---

## 🙌 Credits

Built by [LazyQuad](https://github.com/LazyQuad)  
Technical scripting and documentation by ChatGPT (OpenAI)
