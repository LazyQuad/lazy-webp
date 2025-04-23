# lazy-webp (v1.3.2)

**lazy-webp** is a dual-mode WebP conversion tool by [LazyQuad](https://github.com/LazyQuad)  
designed to help you bulk convert images to SEO-friendly `.webp` format — with optimized naming, optional dimension tagging, and metadata control.

Whether you're on Windows or Linux, use it interactively or with command-line flags for quick automation.

---

## 🔧 Features

- 🖼️ Convert `.jpg`, `.jpeg`, and `.png` images to `.webp`
- 🧠 Batch convert and name (auto-numbered) or manually name each file
- ✍️ SEO-friendly naming with optional dimension tagging (`-WIDTHxHEIGHT`)
- ⚙️ Adjustable quality settings (default 80)
- 🚫 Metadata stripped by default for SEO (EXIF, IPTC, XMP)
- 🗂️ Smart output folder options and overwrite protection
- 🪪 Optional retention of metadata via `--keep-meta`
- 📏 Requires only `cwebp`, but supports optional `identify` for tagging dimensions
- 🧑‍💻 CLI flags supported for advanced scripting
- 💻 Dual support for:
  - Windows `.bat`
  - Linux/macOS/WSL via Bash

---

## 📁 Folder Structure

```
lazy-webp/
├── lazy-webp.bat            ← Launcher for Windows users (detects WSL or forces .bat)
├── basic-convert.bat        ← Simple converter with prompts (Windows only)
├── advanced-convert.sh      ← Full-featured Bash script for WSL/Linux/macOS
├── cwebp/                   ← Drop cwebp.exe here if not in system PATH
├── README.md                ← This file
```

---

## 🚀 Windows Usage

### 🖱️ Interactive Mode (Recommended)

1. Place your `.jpg` or `.png` files in a folder.
2. Place `cwebp.exe` in `lazy-webp/cwebp/` or add it to your PATH.
3. Run:
   - `lazy-webp.bat` — launches either `.bat` or Bash script (if WSL is detected)
   - `basic-convert.bat` — for quick batch conversion with prompts

---

## 🐧 macOS / Linux / WSL Usage

1. Install `cwebp`:
   ```bash
   # Debian/Ubuntu
   sudo apt install webp

   # macOS (with Homebrew)
   brew install webp
   ```

2. Optional (for dimension tagging):
   ```bash
   sudo apt install imagemagick
   ```

3. Make the script executable:
   ```bash
   chmod +x advanced-convert.sh
   ```

4. Run it:
   ```bash
   ./advanced-convert.sh
   ```

5. Or use command-line flags:
   ```bash
   ./advanced-convert.sh \
     --mode batch \
     --base my-image \
     --quality 85 \
     --out ./converted \
     --delete-originals \
     --keep-meta \
     --tag-dimensions
   ```

---

## 🆕 What's New in v1.3.2

- 🎯 New mode: auto-name files based on directory name
- 🔢 Continues numbering from existing files
- 📸 Optional dimension tagging in filenames (e.g., `-1536x1024`)
- 📦 Default metadata stripping for SEO optimization
- 🧩 New flag: `--keep-meta` to retain EXIF/XMP/IPTC
- ❓ Prompt confirmation of selected folders and display defaults
- 🧪 Clean fallback for missing dependencies (`identify`)
- ✅ Normalized file extensions to `.webp`

---

## ⚙️ Requirements

- Windows 10/11 or Linux/macOS with Bash 4+
- `cwebp` (Windows binary or installed via `apt`/`brew`)
- `identify` (optional, for tagging image dimensions)

---

## 💡 Tips

- Use the **advanced Bash version** for automation and SEO control
- Run the **basic version** if you prefer prompts and simplicity
- Manual mode supports `QUIT` to exit anytime
- Input/output folders will be confirmed before processing

---

## 🙌 Credits

Built by [LazyQuad](https://github.com/LazyQuad)  
Batch scripting, Bash logic, and documentation by ChatGPT (OpenAI)
