# Video Compression Script

This project is a **Bash script** designed to compress video files efficiently using **FFmpeg**. The script automatically installs FFmpeg if it's not already installed and supports both macOS and Linux systems.

---

## Features

- **Automatic Installation**: Installs FFmpeg automatically based on the operating system.
- **Custom Quality Options**: Allows users to choose from predefined resolutions (480p, 720p, 1080p) or specify a custom compression ratio.
- **Simple Interface**: Easy-to-use prompts for selecting input files and compression settings.

---

## Requirements

- **Operating System**: macOS or Linux.
- **Dependencies**: FFmpeg (automatically installed if not available).

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/obaidmedweb/video-compression-script.git
   cd video-compression-script
   ```

2. Make the script executable:
   ```bash
   chmod +x video_compressor.sh
   ```

---

## Usage

Run the script using the following command:
```bash
./video_compressor.sh
```

### Steps:
1. Enter the path to the video file you want to compress.
2. Choose one of the available options for compression:
   - **480p**
   - **720p**
   - **1080p**
   - **Custom Compression Ratio** (e.g., 50% of the original size).
3. The script will compress the video and save it as a new file with `_compressed` appended to the original filename.

---

## Example

### Console Output:
```bash
FFmpeg is not installed. Installing now...
FFmpeg installed successfully!
Enter the path to the video file: example.mp4
Choose the desired quality:
1) 480p
2) 720p
3) 1080p
4) Custom Compression Ratio
Enter your choice: 2
Compressing video to 720p...
Compression successful! New file: example_compressed.mp4
```

### Resulting File:
- Original: `example.mp4`
- Compressed: `example_compressed.mp4`

---

## Supported Platforms

- macOS
- Linux (Debian-based, Red Hat-based, Arch-based distributions)

---

## Contributions

Contributions are welcome! Feel free to:
1. Fork the repository.
2. Create a new branch.
3. Submit a pull request with your changes.

---

## Author

Developed by [Obaid](https://github.com/obaidmedweb).

