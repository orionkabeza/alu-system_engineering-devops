# Web stack debugging #1

Second project of the webstack debugging series: given a broken container
where Nginx is installed but not reachable on port 80, diagnose the issue
and capture the fix in a Bash answer script.

## Tasks

- **0-nginx_likes_port_80** — Nginx is not actually installed on the
  container (despite the shell having a leftover config/binary that
  makes it look present at a glance), so `service nginx start` is a
  no-op and `curl 0:80` gets "Connection refused". The fix installs the
  `nginx` package and then starts it through the init script so it
  binds to port 80 on all of the server's active IPv4 interfaces.

- **1-debugging_made_short** *(advanced)* — same underlying problem, but
  the script must be 5 lines or less, cannot use `;`, `&&`, `wget`, or
  call the previous answer file, and afterwards `service nginx status`
  must genuinely report Nginx as not running. The trick is to install
  the package (its postinst does not auto-start the service inside the
  container) and then launch the `nginx` binary directly instead of
  going through `service`/init: the master process starts and answers
  on port 80, but since it was never started via the init script,
  `service nginx status` truthfully has no record of it running.

## How it was diagnosed

```sh
docker run -p 8080:80 -d -it <debugging_1_image>
curl 0:8080                 # curl: (7) Failed to connect - connection refused
docker exec -ti <container_id> bash
service nginx status        # nginx: unrecognized service -> not installed
apt-get install -y nginx    # installs Nginx (service not auto-started)
service nginx start         # starts it
service nginx status        # nginx is running
curl 0:8080                 # -> Welcome to nginx!
```

## Requirements

- Scripts start with `#!/usr/bin/env bash` followed by a comment line
  explaining what they do
- Scripts are executable and pass Shellcheck without errors
- No `wget`
- All files end with a newline
