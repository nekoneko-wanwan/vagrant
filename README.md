vagrantである程度整った仮想環境を直ぐに構築できるセットを用意


#Vagrantfile

* boxにはとりあえずcentos64を想定。boxの名前は適宜変更する。
* ライブリロードが使えるように port:35729をforwardedする
* private_networkでアクセスできるIPを指定
* シェルコマンド、script/bash.shを指定
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

