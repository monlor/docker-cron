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
-e CRON_JOB_EXAMPLE="* * * * * echo 'Hello, World!'" \
-e STARTUP_COMMAND_EXAMPLE="echo 'Container started!'" \
monlor/docker-cron:main
```

### Environment Variables

- `CRON_JOB_<name>`: Define cron jobs. Format: `"<schedule> <command>"`
- `STARTUP_COMMAND_<name>`: Define commands to run at container startup

### Cron Jobs

Cron jobs are added to the container's crontab. The format is:

```
RON_JOB_<name>="<schedule> <command>"
```

Example:

```bash
CRON_JOB_HELLO="* * * * * echo 'Hello, World!'"
```

### Startup Commands

Startup commands are executed at container startup. The format is:

```bash
STARTUP_COMMAND_<name>="<command>"
```

Example:

```bash
STARTUP_COMMAND_INIT="echo 'Initializing...'"
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