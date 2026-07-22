# Web stack debugging #1

Second project of the webstack debugging series: given a broken container
where Nginx is installed but not reachable on port 80, diagnose the issue
and capture the fix in a Bash answer script.

## Tasks

- **0-nginx_likes_port_80** — Nginx is already installed and a master
  process is even running (started at container boot by some mechanism
  outside of `service`/init), but `/etc/nginx/sites-enabled/default` has
  `listen 8080` instead of `listen 80`, so Nginx is only reachable on
  8080 and `curl 0:80` gets "Connection refused". The fix rewrites the
  config to listen on 80, kills the stray process (which is holding
  8080), and starts Nginx properly through the init script.

- **1-debugging_made_short** *(advanced)* — same underlying port bug,
  but the script must be 5 lines or less, cannot use `;`, `&&`, `wget`,
  or call the previous answer file, and afterwards `service nginx
  status` must genuinely report Nginx as not running. Simply launching
  `nginx` directly isn't enough here: the Ubuntu 14.04 init script
  re-derives the pid file path by parsing the `pid` directive straight
  out of `/etc/nginx/nginx.conf`, so as long as Nginx's real pid file
  matches whatever `nginx.conf` says, `service nginx status` finds it
  and reports it as running — even when it wasn't started via `service`.
  The trick is to comment out the `pid` directive in `nginx.conf` (so
  the init script falls back to checking a pid file that will never be
  created, `/run/nginx.pid`) and start Nginx directly with an
  overridden pid path via `nginx -g 'pid /tmp/nginx.pid;'`. Nginx then
  answers on port 80 while genuinely being invisible to `service`.

## How it was diagnosed

```sh
curl -v 0:80                 # curl: (7) Connection refused
service nginx status         # nginx is not running (but a process is alive - see ps)
ps aux | grep nginx          # master process already running, started outside init
netstat -tlnp | grep nginx   # listening on 8080, not 80
grep listen /etc/nginx/sites-enabled/default   # listen 8080 default_server;
sed -i 's/8080/80/g' /etc/nginx/sites-enabled/default
pkill nginx
service nginx start
curl -v 0:80                 # -> Welcome to nginx! (HTTP 200)
service nginx status         # nginx is running
```

## Requirements

- Scripts start with `#!/usr/bin/env bash` followed by a comment line
  explaining what they do
- Scripts are executable and pass Shellcheck without errors
- No `wget`
- All files end with a newline
