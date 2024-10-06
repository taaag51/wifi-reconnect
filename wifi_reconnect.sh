#!/bin/bash

# 現在の日時を取得する関数
get_datetime() {
    date "+%Y-%m-%d %H:%M:%S"
}

# ログをターミナルに表示する関数
log_message() {
    echo "$(get_datetime) - $1"
}

log_message "Wi-Fi監視スクリプトを開始しました。"

while true; do
    if ! ping -c 1 -W 3 google.com &>/dev/null; then
        log_message "インターネット接続が切断されました。Wi-Fiを再接続します。"
        networksetup -setairportpower en0 off
        sleep 5
        networksetup -setairportpower en0 on
        log_message "Wi-Fiを再接続しました。"
    else
        log_message "インターネット接続は正常です。"
    fi
    sleep 15
done
