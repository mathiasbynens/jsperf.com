# jsPerf.com source code

[jsPerf.com](http://jsperf.com/) runs on a Linux server with Apache, MySQL(i) and PHP installed.

## How to run a local copy of jsPerf for testing/debugging

1. Download the source code, as located within this repository.
2. The code expects things to be hosted at `/` and not a subdirectory. You might want to create a new virtual host, e.g. `dev.jsperf.com`.
3. Use `database.sql` to create the jsPerf tables in a database of choice.
4. Rename `_inc/config.sample.php` to `config.php` and enter your database credentials and other info.
5. Edit `.htaccess` (especially the first few lines) so it matches your current setup.
6. Add this to your `vhosts.conf` inside `<VirtualHost foo>`:

```
php_admin_value auto_prepend_file start.php
php_flag magic_quotes_gpc Off
php_admin_value open_basedir /domains/jsperf.com/public_html/www/:/domains/jsperf.com/public_html/www/_tpl/:/domains/jsperf.com/public_html/www/_tpl/tpl-inc/:/domains/jsperf.com/public_html/www/_inc/
php_admin_value include_path /domains/jsperf.com/public_html/www/:/domains/jsperf.com/public_html/www/_tpl/:/domains/jsperf.com/public_html/www/_tpl/tpl-inc/:/domains/jsperf.com/public_html/www/_inc/
php_admin_value file_uploads 0
```

…replacing `/domains/jsperf.com/public_html/www/` with the path to this folder.

## License

The source code for [jsPerf](http://jsperf.com/) is copyright © [Mathias Bynens](http://mathiasbynens.be/) and dual-licensed under the MIT and GPL licenses.

You don’t have to do anything special to choose one license or the other and you don’t have to notify anyone which license you are using. You are free to re-use parts of this code in commercial projects as long as the copyright header (as mentioned in `GPL-LICENSE.txt` and `MIT-LICENSE.txt`) is left intact.