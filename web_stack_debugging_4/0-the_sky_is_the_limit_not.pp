# Raise nginx's open-file limit (ULIMIT) in /etc/default/nginx and restart it,
# so nginx stops running out of file descriptors and failing requests under load.

exec { 'fix-ulimit-for-nginx':
  command => 'sed -i s/15/4096/ /etc/default/nginx && service nginx restart',
  path    => '/usr/bin:/usr/local/bin:/bin:/usr/sbin:/sbin',
}
