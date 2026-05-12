### `music` (YouTube to MP3)
A shell function to quickly extract and download high-quality MP3 audio from YouTube videos.

**Key Features:**
* **WSL Integration:** Automatically detects the Windows username via `cmd.exe` and routes the downloaded file directly to the Windows Desktop (seamlessly handles both standard and OneDrive folder structures).
* **Cross-Platform Fallback:** If executed on a native Linux environment (or if the Windows Desktop path is unresolved), it defaults to saving the file in the current working directory.
* **Playlist Prevention:** Forces single-video downloads, ignoring any playlist parameters included in the provided URL.

**Usage:**
```bash
music "[https://youtube.com/watch?v=](https://youtube.com/watch?v=)..."
