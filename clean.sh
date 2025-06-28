#!/bin/env bash
# 使用说明：
# 1. 将此脚本保存为 clean.sh，放置到 /home/<username>/ 目录下
# 2. 给予执行权限：chmod +x clean.sh
# 3. 以 root 用户运行：sudo ./clean.sh <username>
# 4. 将此脚本添加到 crontab 定时任务中
# 5. sudo crontab -e 
# 6. 添加以下行以每天17点执行清理任务
# 0 17 * * * /home/<username>/clean.sh <username>  # 每天下午5点执行

# 文件所在目录
PWD=$(cd "$(dirname "$0")" && pwd)

# 日志文件
LOG_FILE="$PWD/clean.log"

# 记录日志
log() {
    line="$(date '+%Y-%m-%d %H:%M:%S') - $1"
    echo $line
    echo $line >> "$LOG_FILE"
}

# 接收参数用户名
if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi
USER="$1"
log "Cleaning up for user: $USER"



# 检查是否以 root 权限运行
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

# 检测 Linux 发行版
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    log "Cannot determine distribution"
    exit 1
fi
# 系统发行版为
log "当前系统发行版: $DISTRO"

# 4. 清理日志（保留最近7天）
log "🧹 清理系统日志..."
journalctl --vacuum-time=7d
log "✅ 系统日志已清理"

# 5. 清理临时文件
log "🧹 清理临时文件..."
rm -rf /tmp/*
rm -rf /var/tmp/*
log "✅ 临时文件已清理"

# 6. 清理开发相关的缓存
log "🧹 清理开发相关的缓存..."
if [ -d /var/cache/apt ]; then
    apt-get clean
    log "✅ APT 缓存已清理"
fi

log "🧹 清理 Python pip 缓存..."
if command -v pip >/dev/null 2>&1; then
    pip cache purge
    log "✅ pip 缓存已清理"
fi

log "🧹 清理 Node.js npm 缓存..."
if command -v npm >/dev/null 2>&1; then
    npm cache clean --force
    log "✅ npm 缓存已清理"
fi

log "🧹 清理 Yarn&Cypress 缓存..."
if [ -d /home/$USER/.cache/yarn/ ]; then
    rm -rf /home/$USER/.cache/yarn/*
    rm -rf /home/$USER/.cache/Cypress/*
    log "✅ Yarn&Cypress 缓存已清理"
fi

log "🧹 清理 VSCode 缓存..."
if [ -d /home/$USER/.cache/Code ]; then
    rm -rf /home/$USER/.cache/Code/*
    rm -rf /home/$USER/.cache/vscode-*
    log "✅ VSCode 缓存已清理"
fi

log "🧹 清理 GDB 缓存..."
if [ -d /home/$USER/.cache/gdb ]; then
    rm -rf /home/$USER/.cache/gdb/*
    log "✅ GDB 缓存已清理"
fi

log "🧹 清理 Jetbrians 缓存..."
if [ -d /home/$USER/.cache/JetBrains ]; then
    rm -rf /home/$USER/.cache/JetBrains/*
    log "✅ JetBrains 缓存已清理"
fi

log "🧹 清理 Google 浏览器缓存..."
if [ -d /home/$USER/.cache/Google ]; then
    rm -rf /home/$USER/.cache/Google/*
    log "✅ Google 缓存已清理"
fi

log "🧹 清理 microsoft-edge 缓存..."
if [ -d /home/$USER/.cache/microsoft-edge ]; then
    rm -rf /home/$USER/.cache/microsoft-edge/*
    log "✅ Microsoft Edge 缓存已清理"
fi


log "✅ 清理完成！"



# 最终磁盘使用情况
log "💾 清理后磁盘使用情况："
df -h / | grep -v Filesystem

