# サービス名
## SmokeShift

[![Image from Gyazo](https://i.gyazo.com/8560bba94e95577d9ea35bac53bd9265.jpg)](https://gyazo.com/8560bba94e95577d9ea35bac53bd9265)

## サービス概要
喫煙者の方々が自身の喫煙習慣を可視化し、節約効果を実感できるアプリケーションです。1日の喫煙本数、費用、時間帯などの基本的なデータを記録することで、禁煙や本数削減による効果をわかりやすく確認できます。日々の小さな変化から、将来的な禁煙まで、それぞれのペースに合わせた習慣改善をサポートします。

## このサービスへの思い・作りたい理由
私はSNSで「30年間の禁煙でベンツが購入できる」というツイートと出会いました。この発見から、「日々の小さな節約の積み重ねを、もっと実感できないだろうか」という着想を得ました。

現在喫煙者である私は、1日の喫煙本数や費用、時間帯といった基本的なデータを可視化することで、身近な節約の実感が得られると考えました。例えば、「今日1本我慢したら500円貯まる」といった小さな変化から、喫煙習慣を見直すきっかけになるかもしれません。

本アプリケーションは、完全な禁煙だけでなく、喫煙本数を減らすといった小さな目標から始められる習慣改善ツールを目指しています。日々の小さな変化を可視化することで、ユーザー一人一人の生活に寄り添えるサービスを提供したいと考えています。

## 技術スタック

| カテゴリー     | 使用技術                                    |
|--------------|---------------------------------------------|
| フロントエンド  | Rails 7.1.3.4, JavaScript, TailwindCSS, DaisyUI |
| バックエンド   | Rails 7.1.3.4 (Ruby 3.2.2)                  |
| 認証/API     | LINE Login API                              |
| インフラ      | Render.com                                  |
| DB          | PostgreSQL                                   |
| 開発環境      | Docker                                      |

## 主な機能

| タバコ登録機能 | 喫煙記録機能 |
|------------|------------|
| [![タバコ登録機能](https://i.gyazo.com/f0aec2b8d9c8fbb6dedcf265e297a750.gif)](https://gyazo.com/f0aec2b8d9c8fbb6dedcf265e297a750) | [![喫煙記録機能](https://i.gyazo.com/3591abfc9eb9d5baf86782e54e4159fe.gif)](https://gyazo.com/3591abfc9eb9d5baf86782e54e4159fe) |
| オートコンプリート機能により、簡単にタバコの銘柄と価格を登録できます。 | 登録済みのタバコから選択して喫煙記録を付けることができます。記録は統計、カレンダー、ログにリアルタイムで反映され、ログの削除時も自動更新されます。 |

| 禁煙機能 | 目標金額設定機能 |
|---------|--------------|
| [![禁煙機能](https://i.gyazo.com/36140adb08ab7b46e7aca256d54e4283.gif)](https://gyazo.com/36140adb08ab7b46e7aca256d54e4283) | [![目標金額設定](https://i.gyazo.com/cb8847d6b0e2e085c66779c37ba6d9ed.gif)](https://gyazo.com/cb8847d6b0e2e085c66779c37ba6d9ed) |
| 禁煙ボタンをクリックすることで、禁煙開始を記録できます。開始と同時に禁煙期間のカウントが始まります。 | 現在の目標金額より高い金額で新しい目標を設定可能。アクティブな目標は1つのみで、達成後に新しい目標を作成できます。編集や中断も可能です。 |

## サービスの差別化ポイント・推しポイント

1. **禁煙を促すアプリではなく、禁煙時に役立つアプリ**
   - このアプリは直接的に禁煙を促すのではなく、禁煙を決意したときにサポートを提供するために設計されています。ユーザーが禁煙する準備ができた際に、自身の喫煙データを活用し、具体的な効果を実感できるようにします。
  
2. **喫煙データを活用して金銭的効果を可視化**
   - ユーザーの喫煙データを詳細に記録し、そのデータを基に禁煙の金銭的効果をわかりやすく示します。これにより、ユーザーは禁煙による具体的な節約効果をリアルタイムで実感し、禁煙へのモチベーションを高めることができます。

## 設計

### 画面遷移図
[![画面遷移図](https://i.gyazo.com/484848e1eb51a4659af50ea915186db6.png)](https://gyazo.com/484848e1eb51a4659af50ea915186db6)

[Figmaで詳細を見る](https://www.figma.com/design/TuKVMuL2793wNJ3DJq6PEg/Myapp?node-id=0-1&node-type=canvas&t=PQIKUpqB2HkreYiT-0)

### ER図
[![ER図](https://i.gyazo.com/12628b83616db933785c0dbc819ec760.png)](https://gyazo.com/12628b83616db933785c0dbc819ec760)

[dbdiagram.ioで詳細を見る](https://dbdiagram.io/d/67447e6ee9daa85acaa1d337)