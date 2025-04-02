#!/bin/sh

# 定义安装函数
install_ql() {
    echo "检测到系统类型：$1"
    echo "正在安装青龙面板..."

    # 如果未提供 QL_BRANCH，则根据系统类型设置默认值
    if [ -z "$QL_BRANCH" ]; then
        case "$1" in
            "Alpine Linux") QL_BRANCH="master" ;;
            "Debian"|"Ubuntu (Debian-based)"|"Debian/Ubuntu") QL_BRANCH="debian" ;;
            *) QL_BRANCH="master" ;;  # 其他系统默认使用 master
        esac
    fi

    case "$1" in
        "Alpine Linux")
            # Alpine 安装流程
            set -x
            cat <<EOF >> /etc/profile.d/ql_env.sh
export QL_DIR=/ql
export QL_BRANCH=$QL_BRANCH
export LANG=zh_CN.UTF-8
export SHELL=/bin/bash
export PNPM_HOME=~/.local/share/pnpm
export PATH=\$PATH:~/.local/share/pnpm:~/.local/share/pnpm/global/5/node_modules
EOF
            . /etc/profile
            echo -e "nameserver 119.29.29.29\nnameserver 8.8.8.8" > /etc/resolv.conf
            sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
            apk update -f
            apk upgrade
            apk --no-cache add -f bash make coreutils moreutils git curl wget tzdata perl openssl nginx jq openssh python3 py3-pip
            curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n
            bash n lts
            n 18
            rm -rf /var/cache/apk/*
            apk update
            ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
            echo "Asia/Shanghai" > /etc/timezone
            npm config set registry https://mirrors.cloud.tencent.com/npm/
            npm install -g pnpm
            pnpm add -g pm2 ts-node typescript tslib
            mkdir -p $QL_DIR
            git clone -b $QL_BRANCH https://gitee.com/whyour/qinglong.git $QL_DIR
            cd $QL_DIR
            cp -f .env.example .env
            chmod 777 $QL_DIR/shell/*.sh
            chmod 777 $QL_DIR/docker/*.sh
            pnpm install --prod
            mkdir -p $QL_DIR/static
            git clone -b $QL_BRANCH https://gitee.com/whyour/qinglong-static.git $QL_DIR/static
            ln -s /ql/docker/docker-entrypoint.sh /usr/bin/qinglong
            ;;
        "Debian"|"Ubuntu (Debian-based)"|"Debian/Ubuntu")
            # Debian/Ubuntu 安装流程
            set -x
            cat <<EOF >> /etc/profile.d/ql_env.sh
export QL_DIR=/ql
export QL_BRANCH=$QL_BRANCH
export LANG=zh_CN.UTF-8
export SHELL=/bin/bash
export PNPM_HOME=~/.local/share/pnpm
export PATH=\$PATH:~/.local/share/pnpm:~/.local/share/pnpm/global/5/node_modules
EOF
            . /etc/profile
            apt update
            apt upgrade
            apt install -y nodejs python3-pip npm nginx coreutils git curl wget cron perl sqlite3 libsqlite3-dev jq yq
            npm config set registry https://mirrors.cloud.tencent.com/npm/
            npm install -g pnpm
            pnpm add -g pm2 ts-node typescript tslib
            mkdir -p $QL_DIR
            git clone -b $QL_BRANCH https://gitee.com/whyour/qinglong.git $QL_DIR
            cd $QL_DIR
            cp -f .env.example .env
            chmod 777 $QL_DIR/shell/*.sh
            chmod 777 $QL_DIR/docker/*.sh
            pnpm install --prod
            mkdir -p $QL_DIR/static
            git clone -b $QL_BRANCH https://gitee.com/whyour/qinglong-static.git $QL_DIR/static
            ln -s /ql/docker/docker-entrypoint.sh /usr/bin/qinglong
            ;;
        *)
            echo "错误：不支持的系统类型 '$1'，无法安装青龙面板"
            exit 1
            ;;
    esac

    # 验证安装
    echo "青龙面板安装完成！"
    ql -l check
    qinglong
    ^C
    echo "青龙面板启动成功，浏览器输入127.0.0.1:5700进入后台！"
}

# 主逻辑：先检测系统类型，再调用安装函数
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            alpine)    echo "Alpine Linux" ;;
            debian)    echo "Debian" ;;
            ubuntu)    echo "Ubuntu (Debian-based)" ;;
            *)         echo "Unknown OS: $ID" ;;
        esac
    else
        if command -v apk >/dev/null; then
            echo "Alpine Linux"
        elif command -v apt >/dev/null; then
            echo "Debian/Ubuntu"
        else
            echo "Unknown"
        fi
    fi
}

# 解析命令行参数
while getopts "b:" opt; do
    case $opt in
        b) QL_BRANCH="$OPTARG" ;;
        *) echo "用法: $0 [-b 分支名称]" >&2; exit 1 ;;
    esac
done

# 执行系统检测并安装
OS_TYPE=$(detect_os)
install_ql "$OS_TYPE"