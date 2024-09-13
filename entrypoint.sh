#!/bin/bash

set -u

# Create log directory
[ ! -f /var/log/cron.log ] && touch /var/log/cron.log

# Create crontab file
cat /dev/null > /etc/crontabs/root

# Syntax check function
check_syntax() {
    if ! bash -n <<< "$1"; then
        echo "> Syntax error in command: $1" >&2
        return 1
    fi
    return 0
}

# Configure scheduled tasks
env | grep ^CRON_JOB_ | sort | while read -r var; do
    job_name="$(echo $var | cut -d= -f1 | cut -d_ -f3- | tr '[:upper:]' '[:lower:]')"
    job_schedule="$(echo $var | cut -d= -f2- | cut -d' ' -f1-5)"    
    job_command="$(echo $var | cut -d= -f2- | cut -d' ' -f6-)"
    if check_syntax "$job_command"; then
        echo "${job_schedule} ${job_command} 2>&1 | sed -e \"s/^/[$job_name]: /g\" &> /var/log/cron.log" >> /etc/crontabs/root
        echo "> Added cron job: $job_name"
    else
        echo "> Failed to add cron job due to syntax error: $job_name" >&2
    fi
done

# Configure startup tasks
env | grep ^STARTUP_COMMAND_ | sort | while read -r var; do
    task_name="$(echo $var | cut -d= -f1 | cut -d_ -f3- | tr '[:upper:]' '[:lower:]')"
    task_command="$(echo $var | cut -d= -f2-)"
    
    if check_syntax "$task_command"; then
        echo "> Executing startup task: $task_name"
        eval "$task_command" 2>&1 | sed -e "s/^/[$task_name]: /g"
    else
        echo "> Failed to execute startup task due to syntax error: $task_name" >&2
    fi
done

# Create logrotate configuration file
cat << EOF > /etc/logrotate.d/cron_logs
/var/log/cron.log {
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

# Add logrotate scheduled task to crontab
echo "0 * * * * /usr/sbin/logrotate /etc/logrotate.d/cron_logs" >> /etc/crontabs/root

# Start crond and keep it running in the foreground, while outputting logs
crond 

# Continuously output all log files
exec tail -f /var/log/cron.log
