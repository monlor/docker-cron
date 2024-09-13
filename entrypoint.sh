#!/bin/bash

set -u

# 创建日志目录
[ ! -d /var/log/cron ] && mkdir -p /var/log/cron

# 创建crontab文件
cat /dev/null > /etc/crontabs/root

# 语法检查函数
check_syntax() {
    if ! bash -n <<< "$1"; then
        echo "Syntax error in command: $1" >&2
        return 1
    fi
    return 0
}

# 配置定时任务
for var in $(env | grep ^CRON_JOB_); do
    job_name=$(echo $var | cut -d= -f1 | cut -d_ -f3-)
    job_schedule=$(echo $var | cut -d= -f2- | cut -d' ' -f1-5)
    job_command=$(echo $var | cut -d= -f2- | cut -d' ' -f6-)
    
    if check_syntax "$job_command"; then
        echo "${job_schedule} ${job_command} 2>&1 | tee -a /var/log/cron/${job_name}.log" >> /etc/crontabs/root
        echo "Added cron job: $job_name"
    else
        echo "Failed to add cron job due to syntax error: $job_name" >&2
    fi
done

# 配置启动任务
for var in $(env | grep ^STARTUP_COMMAND_); do
    task_name=$(echo $var | cut -d= -f1 | cut -d_ -f3-)
    task_command=$(echo $var | cut -d= -f2-)
    
    if check_syntax "$task_command"; then
        echo "Executing startup task: $task_name"
        eval "$task_command" 2>&1 | tee -a /var/log/startup_$task_name.log
    else
        echo "Failed to execute startup task due to syntax error: $task_name" >&2
    fi
done

# 创建logrotate配置文件
cat << EOF > /etc/logrotate.d/cron_logs
/var/log/crond.log /var/log/cron/*.log /var/log/startup_*.log {
    size 10M
    rotate 5
    missingok
    notifempty
    compress
    delaycompress
    create 0644 root root
    postrotate
        /usr/bin/killall -HUP crond
    endscript
}
EOF

# 添加logrotate定时任务到crontab
echo "0 * * * * /usr/sbin/logrotate /etc/logrotate.d/cron_logs" >> /etc/crontabs/root

# 启动crond并保持前台运行，同时输出日志
crond -f -d 8 | tee -a /var/log/crond.log &

# 持续输出所有日志文件
exec tail -f /var/log/crond.log /var/log/cron/*.log /var/log/startup_*.log
