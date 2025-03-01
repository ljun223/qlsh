#!/bin/sh

# 定义安装函数
install_ql() {
    echo "检测到系统类型：$1"
    echo "正在安装青龙面板..."

    case "$1" in
        "Alpine Linux")
            # Alpine 安装流程
            set -x \
            && echo -e "\n\
            export QL_DIR=/ql\n\
            export QL_BRANCH=master\n\
            export LANG=zh_CN.UTF-8\n\
            export TERMUX_APK_RELEASE=F-DROID\n\
            export SHELL=/bin/bash\n\
            export PNPM_HOME=~/.local/share/pnpm\n\
            export PATH=$PATH:~/.local/share/pnpm:~/.local/share/pnpm/global/5/node_modules\n" \
            >> /etc/profile.d/ql_env.sh \
            && source /etc/profile \
            && echo -e "nameserver 119.29.29.29\n\
            nameserver 8.8.8.8" > /etc/resolv.conf \
            && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
            && apk update -f \
            && apk upgrade \
            && apk --no-cache add -f bash make \
            coreutils moreutils git curl wget tzdata perl \
            openssl nginx jq openssh python3 py3-pip \
            && curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n \
            && bash n lts \
            && n 18 \
            && rm -rf /var/cache/apk/* \
            && apk update \
            && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
            && echo "Asia/Shanghai" > /etc/timezone \
            && npm config set registry https://registry.npmmirror.com \
            && npm install -g pnpm \
            && pnpm add -g pm2 ts-node typescript tslib \
            && mkdir -p $QL_DIR \
            && git clone -b $QL_BRANCH https://gitee.com/whyour/qinglong.git $QL_DIR \
            && cd $QL_DIR \
            && cp -f .env.example .env \
            && chmod 777 $QL_DIR/shell/*.sh \
            && chmod 777 $QL_DIR/docker/*.sh \
            && pnpm install --prod \
            && mkdir -p $QL_DIR/static \
            && git clone -b $QL_BRANCH https://gitee.com/whyour/qinglong-static.git $QL_DIR/static \
            && ln -s /ql/docker/docker-entrypoint.sh /usr/bin/qinglong \
            ;;
        "Debian"|"Ubuntu (Debian-based)"|"Debian/Ubuntu")
            # Debian/Ubuntu 安装流程
            # 1. 安装相关依赖和青龙面板
            set -x \
            && echo -e "\n\
            export QL_DIR=/ql\n\
            export QL_BRANCH=debian\n\
            export LANG=zh_CN.UTF-8\n\
            export TERMUX_APK_RELEASE=F-DROID\n\
            export SHELL=/bin/bash\n\
            export PNPM_HOME=~/.local/share/pnpm\n\
            export PATH=$PATH:~/.local/share/pnpm:~/.local/share/pnpm/global/5/node_modules\n" \
            >> /etc/profile.d/ql_env.sh \
            && source /etc/profile \
            &&yes | apt install nodejs python3-pip npm nginx coreutils git curl wget  cron sqlite3\
            && npm config set registry https://registry.npmmirror.com \
            && npm install -g pnpm \
            && pnpm add -g pm2 ts-node typescript tslib \
            && mkdir -p $QL_DIR \
            && git clone -b $QL_BRANCH https://gitee.com/whyour/qinglong.git $QL_DIR \
            && cd $QL_DIR \
            && cp -f .env.example .env \
            && chmod 777 $QL_DIR/shell/*.sh \
            && chmod 777 $QL_DIR/docker/*.sh \
            && pnpm install --prod \
            && mkdir -p $QL_DIR/static \
            && git clone -b $QL_BRANCH https://gitee.com/whyour/qinglong-static.git $QL_DIR/static \
            && ln -s /ql/docker/docker-entrypoint.sh /usr/bin/qinglong \
            ;;
        *)
            echo "错误：不支持的系统类型 '$1'，无法安装 青龙面板"
            exit 1
            ;;
    esac

    # 验证安装
    echo "青龙面板安装完成！"
    qinglong
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

# 执行系统检测并安装
OS_TYPE=$(detect_os)
install_ql "$OS_TYPE"
