# コードスタジオ

QRコードと各種バーコードを作成・読み取りできる Flutter アプリです。Android と Web/PWA に対応しています。

## Web 版

<https://mars665.github.io/qr-barcode-studio/>

プライバシーポリシー：<https://mars665.github.io/qr-barcode-studio/privacy.html>

## 主な機能

- QR、JAN/EAN-13、JAN/EAN-8、Code128、Code39、ITF、ISBN の作成
- 入力形式とチェックデジットの検証
- 最大1,000件の連番一括作成と逐次検証
- カメラによるQRコード・バーコード読み取り
- 名前付きカスタムテンプレート、複数可変フィールド、リアルタイムプレビュー
- カスタムテンプレートの編集、コピー、削除とブラウザー内保存（localStorage）
- 入力例、読み取り結果、コピー操作
- カメラ映像と入力データを外部へ送信しないローカル処理

## 開発と検証

```powershell
D:\Dev\flutter\bin\flutter.bat analyze
D:\Dev\flutter\bin\flutter.bat test
D:\Dev\flutter\bin\flutter.bat build web --release --base-href "/qr-barcode-studio/"
```

詳しいローカル環境、Android署名、端末インストール、Git運用については `PROJECT_GUIDE.md` を参照してください。
