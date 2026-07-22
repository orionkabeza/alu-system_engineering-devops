# Web stack debugging #2

Third project of the webstack debugging series, focused on the security
principle of least privilege: never run processes as `root` when a less
privileged user will do.

## Tasks

- **0-iamsomeoneelse** — takes one argument (a username) and runs
  `whoami` as that user with `sudo -u`, so the current shell stays
  `root` but the command executes as the given user.

  ```sh
  ./0-iamsomeoneelse www-data   # -> www-data
  ```

- **1-run_nginx_as_nginx** — reconfigures the container so Nginx runs
  entirely as the unprivileged `nginx` user and listens on all active
  IPv4 IPs on port 8080. The `user nginx;` directive in `nginx.conf`
  only changes the *worker* user; the master process runs as whoever
  starts it. Because port 8080 is above 1024 (no root needed to bind
  it), we start Nginx directly as the `nginx` user with `sudo -u nginx`
  so even the master process runs as `nginx`.

  ```sh
  ps auxff | grep ngin[x]     # master + workers all owned by nginx
  nc -z 0 8080 ; echo $?      # -> 0
  ```

## Requirements

- Interpreted on Ubuntu 14.04 LTS
- Scripts start with `#!/usr/bin/env bash` followed by a comment line
  explaining what they do
- Scripts are executable and pass Shellcheck without errors
- No `apt-get remove` (task 1)
- All files end with a newline
