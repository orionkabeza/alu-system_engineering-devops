# Web server

Configuring a web server (nginx on Ubuntu) entirely through Bash scripts —
no manual editing on the machine, so the same setup can be replayed on any
number of servers.

## Tasks

- **0-transfer_file** — uses `scp` to copy a local file to a remote
  server's home directory. Takes the file path, server IP, username, and
  private key path as arguments; prints a usage message if fewer than 4
  arguments are given.
- **1-install_nginx_web_server** — configures a fresh Ubuntu machine:
  installs nginx, listening on port 80, serving a root page containing
  `Holberton School`. No `systemctl` used.
- **2-setup_a_domain_name** — contains the registered domain name whose
  DNS A record points to the web-01 server.
- **3-redirection** — same as task 1, plus `/redirect_me` answers with a
  `301 Moved Permanently` redirect.
- **4-not_found_page_404** — same as task 3, plus a custom 404 page
  containing `Ceci n'est pas une page`.
- **5-design_a_beautiful_404_page.html** — a designed, human-friendly 404
  page.
