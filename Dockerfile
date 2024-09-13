FROM alpine:3.18

# 安装必要的软件包
RUN apk add --no-cache bash dcron logrotate

# 复制入口脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 设置工作目录
WORKDIR /app

# 设置入口点
ENTRYPOINT ["/entrypoint.sh"]
