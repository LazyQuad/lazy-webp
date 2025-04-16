# lazy-webp (v1.1.0)

**lazy-webp** is a dual-mode WebP conversion tool by [LazyQuad](https://github.com/LazyQuad) designed for converting PNG and JPG images into optimized WebP format for SEO and web performance.

## 🔧 Features

- Batch or manual file naming
- CLI flags for automation OR interactive mode
- Smart quality and metadata options
- Works via WSL (Bash) or plain Windows Batch
- Simple drop-in setup with cwebp.exe support

## 📦 Structure

```
lazy-webp/
├── lazy-webp.bat            ← Launcher (detects WSL, prompts user)
├── basic-convert.bat        ← Simple batch-mode for Windows
├── advanced-convert.sh      ← Bash version with CLI and interactive support
├── cwebp/                   ← Drop cwebp.exe here (or use system PATH)
├── README.md                ← This file
```

## 🚀 Usage

### 🔁 Batch Mode

```bash
./advanced-convert.sh --mode batch --base "image-name" --quality 85 --out ./webp --strip-meta
```

### 🧑 Manual Prompt Mode

```bash
./advanced-convert.sh
```

### 🪟 On Windows

1. Drop `cwebp.exe` in the `cwebp/` folder
2. Run `lazy-webp.bat` or `basic-convert.bat` directly

---

## 🆕 What's New in v1.1.0

- 🖼️ Basic Batch Script Improvements:
  - Cleaned up prompts and formatting
  - Output directory auto-creates if missing
  - Proper filename generation in batch mode
  - Manual rename mode supports typing `QUIT` to exit mid-process
  - Fixed delayed variable expansion and control flow

---

## 💡 Tips

- In manual mode, type `QUIT` to exit the loop early
- Hold `Ctrl+C` before the loop starts to safely abort
- `lazy-webp.bat` lets you choose Bash or Batch on Windows
