# Web stack debugging #0

First project of the webstack debugging series: given a broken container,
diagnose what's wrong and fix it, capturing the exact fix commands in a
Bash answer script.

## Tasks

- **0-give_me_a_page** — the `holbertonschool/265-0` container has Apache
  installed but it isn't running, so `curl` on port 80 gets an empty/reset
  reply. The fix simply starts the `apache2` service.

## How it was diagnosed

```sh
docker run -p 8080:80 -d -it holbertonschool/265-0
curl 0:8080                       # connection reset / empty reply
docker exec -ti <container_id> bash
service apache2 status            # apache2 is not running
service apache2 start             # starts it
curl 0:8080                       # -> Hello Holberton
```
