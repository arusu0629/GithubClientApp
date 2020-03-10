# GithubClientApp
Github Client App with (UIKit + Storyboard)

### 追加した機能
- ユーザ検索画面をVIPERアーキテクチャに則って実装
- API通信中にローディング表示を実装
  - 当初はSVProgressHUDライブラリを用いて実装していたが、iOS13とその他のiOSバージョンでの共存が出来なかったため標準のUIActivityIndicatorViewを使用
- 空文字検索した際のエラーハンドリングとしてアラートを表示してユーザが分かるように実装
- KingFisherライブラリを用いる事でUITableViewのリスト表示がヌルヌル動くよう実装

### もう少しこだわりたかった点
- 0件表示の実装
  - エラー時同様にアラートを出すぐらいはしても良かった  
- ユーザ詳細ページのブラウザ内で戻るボタンの表示

### Demo
![demo](https://raw.githubusercontent.com/wiki/arusu0629/GithubClientApp/Images/GithubClientApp.gif)
