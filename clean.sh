#!/bin/bash

# 每天早上10点和下午5点执行清理脚本
# 在 /etc/crontab 中添加以下行
# 0 10 * * 1 /clean.sh  
# 0 17 * * 1 /clean.sh


# 日志文件
LOG_FILE="/var/log/cleanup.log"

# 记录日志
log() {
    line="$(date '+%Y-%m-%d %H:%M:%S') - $1"
    echo $line
    echo $line >> "$LOG_FILE"
}

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

 clearKernel (){

# 获取当前运行的内核
current_kernel=$(uname -r)
log "Current kernel: $current_kernel"

# 根据发行版清理内核
case "$DISTRO" in
    ubuntu|debian)
        # 获取已安装的内核（排除当前内核），保留最新两个
        kernels=$(dpkg --list | grep linux-image | grep -v "$current_kernel" | awk '{print $2}' | sort -V | head -n -2)
        if [ -z "$kernels" ]; then
            log "No excess kernels to remove."
            exit 0
        fi
        # 删除多余内核
        for kernel in $kernels; do
            log "Removing kernel: $kernel"
            apt-get purge -y "$kernel" >> "$LOG_FILE" 2>&1
            if [ $? -eq 0 ]; then
                log "Successfully removed $kernel"
            else
                log "Failed to remove $kernel"
            fi
        done
        # 清理依赖和缓存
        log "Running autoremove and autoclean"
        apt-get autoremove -y >> "$LOG_FILE" 2>&1
        apt-get autoclean >> "$LOG_FILE" 2>&1
        # 更新 GRUB
        log "Updating GRUB"
        update-grub >> "$LOG_FILE" 2>&1
        log "Cleanup completed"
        ;;

    centos|rhel)
        # 获取已安装的内核（排除当前内核），保留最新两个
        kernels=$(rpm -qa | grep kernel | grep -v "$current_kernel" | sort -V | head -n -2)
        if [ -z "$kernels" ]; then
            log "No excess kernels to remove."
            exit 0
        fi
        # 删除多余内核
        for kernel in $kernels; do
            log "Removing kernel: $kernel"
            yum remove -y "$kernel" >> "$LOG_FILE" 2>&1
            if [ $? -eq 0 ]; then
                log "Successfully removed $kernel"
            else
                log "Failed to remove $kernel"
            fi
        done
        # 清理缓存
        log "Cleaning yum cache"
        yum clean all >> "$LOG_FILE" 2>&1
        # 更新 GRUB
        log "Updating GRUB"
        grub2-mkconfig -o /boot/grub2/grub.cfg >> "$LOG_FILE" 2>&1
        log "Cleanup completed"
        ;;

    fedora)
        # 获取已安装的内核（排除当前内核），保留最新两个
        kernels=$(rpm -qa | grep kernel | grep -v "$current_kernel" | sort -V | head -n -2)
        if [ -z "$kernels" ]; then
            log "No excess kernels to remove."
            exit 0
        fi
        # 删除多余内核
        for kernel in $kernels; do
            log "Removing kernel: $kernel"
            dnf remove -y "$kernel" >> "$LOG_FILE" 2>&1
            if [ $? -eq 0 ]; then
                log "Successfully removed $kernel"
            else
                log "Failed to remove $kernel"
            fi
        done
        # 清理缓存
        log "Cleaning dnf cache"
        dnf clean all >> "$LOG_FILE" 2>&1
        # 更新 GRUB
        log "Updating GRUB"
        grub2-mkconfig -o /boot/grub2/grub.cfg >> "$LOG_FILE" 2>&1
        log "Cleanup completed"
        ;;

    *)
        log "Unsupported distribution: $DISTRO"
        exit 1
        ;;
esac
}

# 4. 清理日志（保留最近7天）
log "📜 清理系统日志..."
journalctl --vacuum-time=7d
log "✅ 系统日志已清理"

# 5. 清理临时文件
log "🗑 清理临时文件..."
rm -rf /tmp/*
rm -rf /var/tmp/*
log "✅ 临时文件已清理"

# 6. 清理内核
clearKernel

# 最终磁盘使用情况
log "----------------------------------------"
log "💾 清理后磁盘使用情况："
df -h / | grep -v Filesystem
log "✅ 清理完成！"
