vagrantである程度整った仮想環境を直ぐに構築できるセットを用意


#Vagrantfile

* boxにはとりあえずcentos64を想定。boxの名前は適宜変更する。
* ライブリロードが使えるように port:35729をforwardedする
* private_networkでアクセスできるIPを指定
* 実行するパッチとして、script/bash.shもしくはphpMyAdmin.shを指定
* /var/www/html/public_html/以下を、同期フォルダとしrsyncさせる *1

※1) windowsではrsyncのインストールが必要

#script/bash.sh

* httpdのインストールと自動立ち上げ
* iptablesの停止
* httpd.confのバックアップを取り修正
* welcome.confの修正
* nodejs, npmのインストール
* gulpのインストール
* ruby, ruby-devel, rubygemsのインストール
* sass, compassのインストール

#script/phpMyAdmin.sh

- httpd ~ welcom.confまで同じ
- php install
- MySQL install
- phpMyAdmin install

---------

* http://192.168.xx.xx/phpmyadmin/ でアクセスできる
* phpMyAdmin のID/PWはMySQLに設定したものと同じ


## wordpressのインストール

### 前提条件
- wpは複数インストールするが、マルチサイトは使用せずにすべてDB/ユーザを分ける

### phpMyAdminでの作業
- MySQLに必要なブログのDBを作成する
- MySQLに上記ブログにログインする管理ユーザを作成する

### 残りの作業
- パブリックディレクトリにWPを丸ごと入れる
- 該当ディレクトリにブラウザでアクセスして作成したDB/ユーザ名で初期化する

> そのままではwp-configに書き込めないのでローカルで上書き→rsyncしてやる
> 後ほどchownで変更してやる
