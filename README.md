# StrokeRemap

這是一個 macOS Menu Bar 工具，專門為中文筆劃輸入法重新映射鍵位，讓 macOS 上的輸入體驗更接近 iOS。

## 功能

### 字母鍵盤模式

| 筆劃 | macOS | StrokeRemap |
| ---- | ----- | ----------- |
| 丶   | U     | J           |
| 乛   | I     | K           |
| \*   | O     | L           |
| 一   | J     | U           |
| 丨   | K     | I           |
| 丿   | L     | O           |

### 數字鍵盤模式

| 筆劃 | macOS | StrokeRemap |
| ---- | ----- | ----------- |
| 丶   | 4     | 1           |
| 乛   | 5     | 2           |
| \*   | 6     | 3           |
| 一   | 1     | 4           |
| 丨   | 2     | 5           |
| 丿   | 3     | 6           |

### 支援的輸入法

- 廣東話筆劃
- 繁體中文筆劃
- 簡體中文筆劃

## 使用方法

1. 啟動 StrokeRemap 後，點擊 Menu Bar 的鍵盤圖示。
2. 點選「系統授權」。
3. 系統會開啟「隱私權與安全性 > 輔助使用」，勾選 StrokeRemap。
4. 在 Menu Bar 選單中點擊「啟用」。

## Requirements

- macOS 14.6+
- Accessibility permissions

## Installation

> [!NOTE]
> This app is unsigned. You can either build it from source or bypass macOS Gatekeeper for the pre-built binary.

### Pre-built binary

1. Download the latest release from the [Releases](https://github.com/lcweden/stroke-remap/releases) page.
2. Open the downloaded `.app` file and drag to your Applications folder.
3. First launch:
   - Try right-clicking (Control-click) `StrokeRemap.app` in Finder and choose **Open**.
   - If macOS still blocks it, open **System Settings → Privacy & Security**, scroll down, and click **Open Anyway** for StrokeRemap.
4. Once the app launches, you will see the StrokeRemap icon in the menu bar.

### Build from source code

1. Clone the repository.
2. Open `StrokeRemap.xcodeproj` in Xcode.
3. Build and run the project.

## License

This project is licensed under the Apache License 2.0.
