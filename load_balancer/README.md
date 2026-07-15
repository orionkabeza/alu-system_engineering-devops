# Load balancer

Adding redundancy to the web stack: two identical web servers (web-01,
web-02) behind an HAProxy load balancer (lb-01), distributing traffic with
a round-robin algorithm.

## Tasks

- **0-custom_http_response_header** — configures a fresh Ubuntu machine
  identically to web-01 (nginx, `/redirect_me` 301 redirect, custom 404
  page) and adds a custom `X-Served-By` response header set to the
  server's own hostname, so requests can be traced back to the web server
  that answered them. Run on both web-01 and web-02.
- **1-install_load_balancer** — installs and configures HAProxy on lb-01,
  balancing traffic across web-01 and web-02 with round robin, managed via
  an init script.
