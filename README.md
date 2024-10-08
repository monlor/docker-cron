# Docker Cron

[![GitHub Packages](https://img.shields.io/badge/GitHub%20Packages-docker--cron-blue?logo=github)](https://github.com/monlor/docker-cron/pkgs/container/docker-cron)
[![GitHub release](https://img.shields.io/github/release/monlor/docker-cron.svg)](https://github.com/monlor/docker-cron/releases)
[![GitHub license](https://img.shields.io/github/license/monlor/docker-cron.svg)](https://github.com/monlor/docker-cron/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/monlor/docker-cron.svg)](https://github.com/monlor/docker-cron/issues)
[![GitHub stars](https://img.shields.io/github/stars/monlor/docker-cron.svg)](https://github.com/monlor/docker-cron/stargazers)

A lightweight Docker image based on Alpine Linux for running cron jobs and startup commands with automatic log rotation.

## Features

- Based on Alpine Linux 3.18
- Runs cron jobs defined through environment variables
- Executes startup commands
- Automatic log rotation using logrotate
- Real-time log output

## Usage

### Running the container

```bash
docker run -d \
-e CRON_JOB_EXAMPLE1="* * * * * echo 'Hello, World!'" \
-e CRON_JOB_EXAMPLE2="0 2 * * * echo 'Hourly task'" \
-e STARTUP_COMMAND_EXAMPLE1="echo 'Container started!'" \
-e STARTUP_COMMAND_EXAMPLE2="echo 'Initializing services...'" \
-e STARTUP_CONDITION="curl -s http://localhost:3000" \
monlor/docker-cron:main
```

### Environment Variables

- `CRON_JOB_<name>`: Define cron jobs. Format: `"<schedule> <command>"`
- `STARTUP_COMMAND_<name>`: Define commands to run at container startup
- `STARTUP_CONDITION`: Define a condition that must be met before starting services

### Cron Jobs

Cron jobs are added to the container's crontab. The format is:

```
RON_JOB_<name>="<schedule> <command>"
```

Example:

```bash
CRON_JOB_HELLO="* * * * * echo 'Hello, World!'"
CRON_JOB_BACKUP="0 2 * * * curl -sSf https://example.com/api/backup"
```

### Startup Commands

Startup commands are executed at container startup. The format is:

```bash
STARTUP_COMMAND_<name>="<command>"
```

Example:

```bash
STARTUP_COMMAND_INIT="echo 'Initializing...'"
STARTUP_COMMAND_CONFIG="curl -sSf https://example.com/api/config"
```

### Startup Condition

You can set a startup condition that must be met before the container starts its services. This is useful for ensuring dependencies are ready. The format is:

```bash
STARTUP_CONDITION="<command>"
```

Example:

```bash
STARTUP_CONDITION="curl -sSf https://example.com/api/health &> /dev/null"
```

## Log Management

- Logs are stored in `/var/log/cron/` and `/var/log/`
- Log rotation is configured to:
  - Rotate files when they reach 10MB
  - Keep 5 rotated log files
  - Compress old log files

## Building the Image

To build the Docker image:

```bash
docker build -t your-image-name .
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the [MIT License](LICENSE).