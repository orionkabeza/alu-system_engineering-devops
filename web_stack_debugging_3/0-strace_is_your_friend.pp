# Fixes the Apache 500 error caused by a '.phpp' typo in wp-settings.php
# (strace shows Apache/PHP failing to open a misspelled file with ENOENT).

exec { 'fix-wordpress':
  command => 'sed -i s/.phpp/.php/g /var/www/html/wp-settings.php',
  path    => '/usr/bin:/usr/local/bin:/bin:/usr/sbin:/sbin',
}
