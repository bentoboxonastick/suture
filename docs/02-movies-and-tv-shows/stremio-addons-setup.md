# Stremio Addons & Debrid Setup Guide

Suture supports the community-standard **Stremio Addon Protocol v3**, allowing you to aggregate metadata catalogs, stream sources, and subtitles from open protocol endpoints.

---

## ⚡ Adding a Stremio v3 Addon

1. In Suture, go to **Settings → Addons**.
2. Tap **Add Custom Addon** (or press `Cmd + N`).
3. Enter the manifest URL of your addon (for example, `https://v3-cinemeta.strem.io/manifest.json` or `stremio://...`).
4. Suture will validate the manifest and immediately integrate the catalogs and streams into your universal library.

---

## 🚀 Debrid Fast Streaming (Real-Debrid / AllDebrid)

If you use an HTTPS Debrid unrestrict service:
1. Navigate to **Settings → Accounts → Debrid**.
2. Select your provider (**Real-Debrid**, **AllDebrid**, or **Premiumize**).
3. Paste your private API Key / Token.
4. Suture will automatically inspect torrent infohashes, detect instant cloud-cached streams, and unrestrict them into direct, high-bandwidth HTTPS streams with zero buffering.

---

## 🎬 Video Player Features

When streaming video in Suture:
- **Audio Tracks**: Select between multiple audio languages, stereo, and 5.1 surround sound from the `captions.bubble` menu.
- **Subtitles**: Toggle embedded subtitles or external SRT/VTT sidecar tracks.
- **External Player Launch**: Long-press any stream or tap `...` to open directly in **Infuse**, **VLC**, or **IINA**.
