# QR / 条码工具项目操作手册

最后更新：2026-08-08

## 1. 项目基本信息

- 项目目录：`D:\Codex\New project\starter_app`
- Flutter SDK：`D:\Dev\flutter`
- Android SDK：`D:\Android\Sdk`
- Android AVD 目录：`D:\Android\Avd`
- 模拟器：`Pixel_7_API_36`
- Android 包名：`com.example.starter_app`
- Git 默认分支：`main`
- GitHub 仓库：<https://github.com/mars665/qr-barcode-studio>
- Git 提交身份：`slw <shanlw1983@gmail.com>`

## 2. 重要签名信息

当前测试版本必须固定使用以下调试密钥：

```text
D:\Android\debug.keystore
```

对应证书 SHA-256：

```text
c0ebb9a3afb92288665ef336fab7679dc94329b121e562a5b85a09e7f450c8bd
```

构建前必须设置：

```powershell
$env:ANDROID_USER_HOME = "D:\Android"
```

否则 Gradle 会改用：

```text
C:\Users\Administrator\.android\debug.keystore
```

该密钥的证书不同，生成的 APK 无法覆盖手机上的现有版本，会出现：

```text
INSTALL_FAILED_UPDATE_INCOMPATIBLE
```

不要把任何 `*.keystore`、`*.jks`、`key.properties`、密码或 Token 提交到 Git。

## 3. 常用环境设置

在新的 PowerShell 窗口中执行 Android/Flutter 命令前，可先设置：

```powershell
$env:ANDROID_HOME = "D:\Android\Sdk"
$env:ANDROID_SDK_ROOT = "D:\Android\Sdk"
$env:ANDROID_USER_HOME = "D:\Android"
```

如果 Google Flutter 存储无法访问，可临时使用：

```powershell
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"
$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
```

## 4. 检查、测试和构建

进入项目：

```powershell
cd "D:\Codex\New project\starter_app"
```

静态检查：

```powershell
D:\Dev\flutter\bin\flutter.bat analyze
```

运行测试：

```powershell
D:\Dev\flutter\bin\flutter.bat test
```

构建测试用 Release APK：

```powershell
$env:ANDROID_HOME = "D:\Android\Sdk"
$env:ANDROID_SDK_ROOT = "D:\Android\Sdk"
$env:ANDROID_USER_HOME = "D:\Android"
D:\Dev\flutter\bin\flutter.bat build apk --release
```

APK 输出位置：

```text
D:\Codex\New project\starter_app\build\app\outputs\flutter-apk\app-release.apk
```

注意：当前 `release` 构建仍使用调试签名，只适合内部测试，不适合应用商店正式发布。

## 5. 手机连接与安装

曾连接成功的测试手机：

- 型号：`A202ZT`
- 当时的设备序列号：`320636588564`

设备序列号可能变化或连接其他手机，因此安装前先检查：

```powershell
D:\Android\Sdk\platform-tools\adb.exe devices -l
```

手机状态必须显示为 `device`。如果显示 `unauthorized`，在手机上允许 USB 调试。

安装 APK：

```powershell
D:\Android\Sdk\platform-tools\adb.exe -s 设备序列号 install -r "D:\Codex\New project\starter_app\build\app\outputs\flutter-apk\app-release.apk"
```

启动 App：

```powershell
D:\Android\Sdk\platform-tools\adb.exe -s 设备序列号 shell am start -n com.example.starter_app/.MainActivity
```

进入扫码页面时，手机需要允许相机权限。

## 6. 模拟器启动

已配置的 AVD：

```text
D:\Android\Avd\Pixel_7_API_36.avd
```

启动前设置：

```powershell
$env:ANDROID_SDK_ROOT = "D:\Android\Sdk"
$env:ANDROID_HOME = "D:\Android\Sdk"
$env:ANDROID_AVD_HOME = "D:\Android\Avd"
$env:ANDROID_USER_HOME = "D:\Android"
```

启动模拟器：

```powershell
D:\Android\Sdk\emulator\emulator.exe -avd Pixel_7_API_36
```

在模拟器运行项目：

```powershell
D:\Dev\flutter\bin\flutter.bat run -d emulator-5554
```

端口编号不一定始终是 `emulator-5554`，应先用 `adb devices -l` 确认。

## 7. Git 日常流程

查看状态和修改：

```powershell
git status
git diff
```

只选择本次要提交的文件：

```powershell
git add lib/main.dart test/widget_test.dart README.md
```

一个文件只暂存部分修改：

```powershell
git add -p lib/main.dart
```

检查暂存区：

```powershell
git diff --cached
git status
```

提交并推送：

```powershell
git commit -m "简明说明本次修改"
git push
```

取消暂存但保留代码修改：

```powershell
git restore --staged 文件路径
```

推荐顺序：

```text
git pull → 修改 → analyze/test → git diff → git add → git commit → git push
```

## 8. 当前功能和状态

已实现：

- QR 码生成
- JAN/EAN-13、JAN/EAN-8、Code128、Code39、ITF、ISBN 生成
- 单个数据格式验证
- 连号批量生成，最多 1,000 条
- 批量数据逐条有效性检查
- 根据所选类型显示输入示例
- 摄像头扫描和结果复制
- Android 相机权限配置

最近一次验证：

- Dart 静态分析通过
- 4 个 Widget 测试全部通过
- Release APK 构建成功
- APK 已在 `A202ZT` 手机上覆盖安装并启动

## 9. 已知事项

- `mobile_scanner` 当前会产生 Kotlin Gradle Plugin 未来兼容性警告，现阶段不影响构建。
- QR 误差校正等级选择 UI 尚未实现；曾有旧测试期待该 UI，测试现已按当前真实功能调整。
- 正式发布前必须创建专用 Release keystore，并妥善备份；不要继续使用 debug keystore 发布。
- 不要删除现有文件或覆盖用户修改。修改前先运行 `git status` 和 `git diff`。

## 10. 备份

初始功能版本备份：

```text
D:\Codex\New project\starter_app-backup-20260808-014319.zip
```

备份 SHA-256：

```text
6052BD22F844077F100AA551CBD39D4F99721341650B523CF26B7EF8BE377572
```

