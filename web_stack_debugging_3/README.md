# Web stack debugging #3

Fourth project of the webstack debugging series. This time the fix is
automated with **Puppet** instead of Bash.

## Task

- **0-strace_is_your_friend.pp** — Apache serves a WordPress site but
  returns `500 Internal Server Error`. Attaching `strace` to the Apache
  worker while issuing a `curl` (e.g. in a second `tmux` pane) shows a
  failed `open()` syscall returning `-1 ENOENT` for a misspelled PHP
  file — a `.phpp` typo in `/var/www/html/wp-settings.php`. The Puppet
  manifest uses an `exec` resource that runs `sed` to correct the typo,
  after which Apache returns `200 OK` and the Holberton WordPress page
  loads.

## How it was diagnosed

```sh
# pane 1: attach strace to the running apache processes
strace -p <apache_pid> -f -e trace=open,openat 2>&1 | grep -i php
# pane 2: trigger the request
curl -sI 127.0.0.1
# -> strace reveals: open("/var/www/html/wp-includes/....phpp") = -1 ENOENT
```

## Fix

```sh
puppet apply 0-strace_is_your_friend.pp
curl -sI 127.0.0.1        # -> HTTP/1.1 200 OK
```

## Requirements

- Interpreted / run on Ubuntu 14.04 LTS
- `0-strace_is_your_friend.pp` contains Puppet code
- File ends with a newline
