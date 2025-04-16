# lazy-webp

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
2. Double-click `lazy-webp.bat` and follow prompts

## 🔗 Download cwebp

[Download from Google](https://developers.google.com/speed/webp/download)

---

Created with ❤️ by [LazyQuad](https://github.com/LazyQuad)
