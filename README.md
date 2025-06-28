# shell.sh - Linux系统清理脚本
## 使用方法：

1. 将此脚本保存为 clean.sh
2. 给予执行权限：chmod +x clean.sh
3. 以 root 用户运行：sudo ./clean.sh <username>
4. 将此脚本添加到 crontab 定时任务中
```
执行`crontab -e`添加以下行以每天17点执行清理任务
0 17 * * * /clean.sh <username>  # 每天下午5点执行
```
## 输出效果如下:
```
2025-06-28 09:27:17 - Cleaning up for user: gaojie
2025-06-28 09:27:17 - 当前系统发行版: ubuntu
2025-06-28 09:27:17 - 🧹 清理系统日志...
Vacuuming done, freed 0B of archived journals from /run/log/journal/919cd5c32b7546c28789113fa3342de1.
Vacuuming done, freed 0B of archived journals from /run/log/journal.
2025-06-28 09:27:17 - ✅ 系统日志已清理
2025-06-28 09:27:17 - 🧹 清理临时文件...
2025-06-28 09:27:17 - ✅ 临时文件已清理
2025-06-28 09:27:17 - 🧹 清理开发相关的缓存...
2025-06-28 09:27:17 - ✅ APT 缓存已清理
2025-06-28 09:27:17 - 🧹 清理 Python pip 缓存...
WARNING: No matching packages
Files removed: 0
2025-06-28 09:27:17 - ✅ pip 缓存已清理
2025-06-28 09:27:17 - 🧹 清理 Node.js npm 缓存...
npm warn using --force Recommended protections disabled.
2025-06-28 09:27:17 - ✅ npm 缓存已清理
2025-06-28 09:27:17 - 🧹 清理 Yarn&Cypress 缓存...
2025-06-28 09:27:17 - ✅ Yarn&Cypress 缓存已清理
2025-06-28 09:27:17 - 🧹 清理 VSCode 缓存...
2025-06-28 09:27:17 - ✅ VSCode 缓存已清理
2025-06-28 09:27:17 - 🧹 清理 GDB 缓存...
2025-06-28 09:27:17 - ✅ GDB 缓存已清理
2025-06-28 09:27:17 - 🧹 清理 Jetbrians 缓存...
2025-06-28 09:27:17 - ✅ JetBrains 缓存已清理
2025-06-28 09:27:17 - 🧹 清理 Google 浏览器缓存...
2025-06-28 09:27:17 - ✅ Google 缓存已清理
2025-06-28 09:27:18 - 🧹 清理 microsoft-edge 缓存...
2025-06-28 09:27:18 - ✅ Microsoft Edge 缓存已清理
2025-06-28 09:27:18 - ✅ 清理完成！
2025-06-28 09:27:18 - 💾 清理后磁盘使用情况：
/dev/mapper/vgkubuntu-root  467G  289G  154G  66% /
```