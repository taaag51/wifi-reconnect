#!/bin/bash

# 現在の日時を取得する関数
get_datetime() {
    date "+%Y-%m-%d %H:%M:%S"
}

# ログをターミナルに表示する関数
log_message() {
    echo "$(get_datetime) - $1"
}

# インターネット接続をチェックする関数
check_internet() {
    ping -c 1 -W 3 google.com &>/dev/null
}

log_message "Wi-Fi監視スクリプトを開始しました。"

while true; do
    if ! check_internet; then
        log_message "インターネット接続が切断されました。Wi-Fiを再起動します。"
        networksetup -setairportpower en0 off
        sleep 5
        networksetup -setairportpower en0 on
        log_message "Wi-Fiを再起動しました。再接続を確認中..."

        # 再接続の確認（最大5回試行）
        for i in {1..5}; do
            sleep 10 # 接続が確立するまで少し待機
            if check_internet; then
                log_message "インターネット接続が復旧しました。"
                break
            elif [ $i -eq 5 ]; then
                log_message "インターネット接続の復旧に失敗しました。次の確認まで待機します。"
            else
                log_message "再接続を再確認中... (試行 $i/5)"
            fi
        done
    else
        log_message "インターネット接続は正常です。"
    fi
    sleep 15
done
