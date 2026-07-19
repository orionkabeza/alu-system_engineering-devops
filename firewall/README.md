# Firewall

Locking down a server with `ufw` so that only the traffic it actually needs
to serve (SSH, HTTP, HTTPS) is reachable, and everything else is blocked by
default.

## Tasks

- **0-block_all_incoming_traffic_but** — installs `ufw` on web-01, allows
  22/tcp (SSH), 80/tcp (HTTP) and 443/tcp (HTTPS), sets the default policy
  to deny all other incoming traffic (outgoing traffic stays allowed), then
  enables the firewall.

## Notes

- Port 22 must be allowed **before** `ufw` is enabled — otherwise the SSH
  session gets locked out with no way to reconnect.
- Because the school network filters outgoing connections, testing whether
  a port is open on web-01 has to be done from *outside* the school network
  — e.g. by SSHing into web-02 first and running `telnet <web-01 IP> <port>`
  from there, so the traffic originates from web-02 rather than the school.
