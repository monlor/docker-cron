FROM alpine:3.18

# Install necessary packages including tini
RUN apk add --no-cache bash dcron logrotate curl tini

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the working directory
WORKDIR /app

# Use tini as the entry point
ENTRYPOINT ["/sbin/tini", "--"]

# Set the default command to run our entrypoint script
CMD ["/entrypoint.sh"]
