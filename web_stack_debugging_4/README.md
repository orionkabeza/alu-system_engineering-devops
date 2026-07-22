# Web stack debugging #4

Fifth project of the webstack debugging series: an Nginx stack that
collapses under load. Fixed and automated with **Puppet**.

## Task

- **0-the_sky_is_the_limit_not.pp** — under an ApacheBench load test
  (`ab -c 100 -n 2000 localhost/`) a large number of requests fail with
  non-2xx responses. The cause is in `/etc/default/nginx`, which ships
  with `ULIMIT="-n 15"` — each Nginx worker is capped at 15 open file
  descriptors, so it runs out almost immediately under concurrency. The
  Puppet manifest raises the limit to `4096` and restarts Nginx so the
  new limit takes effect, bringing failed requests to 0.

## How it was diagnosed

```sh
ab -c 100 -n 2000 localhost/     # -> hundreds of Failed requests (Length)
cat /etc/default/nginx           # -> ULIMIT="-n 15"
```

## Fix

```sh
puppet apply 0-the_sky_is_the_limit_not.pp
ab -c 100 -n 2000 localhost/     # -> Failed requests: 0
```

## Requirements

- Interpreted / run on Ubuntu 14.04 LTS
- `0-the_sky_is_the_limit_not.pp` contains Puppet code
- File ends with a newline
