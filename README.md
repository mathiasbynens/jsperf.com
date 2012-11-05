# jsPerf.com source code

[jsPerf.com](http://jsperf.com/) runs on a server with Apache or Lighttpd,
MySQL and PHP installed.

## How to run a local copy of jsPerf for testing/debugging

1. Download the source code, as located within this repository.
2. The code expects things to be hosted at `/` and not a subdirectory. You might
   want to create a new virtual host, e.g. `dev.jsperf.com`.
3. Use `_tmp/database.sql` to create the jsPerf tables in a database of choice.
4. Rename `_inc/config.sample.php` to `_inc/config.php` and enter your database
   credentials and other info.
5. For the Browserscope integration to work, you’ll need a Browserscope API key.
   To get one, sign in at [Browserscope.org](http://www.browserscope.org/) and
   then browse to [the settings page](http://www.browserscope.org/user/settings).
6. If you are using Apache, edit `.htaccess` (especially the first few lines)
   so it matches your current setup. If you are using Lighttpd, set up the
   `dev.jsperf.com` virtual host using the sample in `_inc/lighttpd.conf`.
7. If you plan on using the update script for Benchmark.js/Platform.js
   (`_tmp/build.php`), you’ll need to make some files writable.

   ```bash
   chmod 666 _js/benchmark.js _js/benchmark.src.js _js/platform.src.js\
   _js/ui.browserscope.src.js _js/ui.src.js _inc/version.txt
   ```

Note that both `include_path` and `open_basedir` must be set to `./:./_tpl/:./_tpl/tpl-inc/:./_inc/`.

With PHP 5.4 you can easily start an HTTP web server with these settings for quick testing:

    php -d include_path="./:./_tpl/:./_tpl/tpl-inc/:./_inc/" -d open_basedir="./:./_tpl/:./_tpl/tpl-inc/:./_inc/" -d session.save_path="_session" -S localhost:8000

## License

The source code for [jsPerf](http://jsperf.com/) is copyright
© [Mathias Bynens](http://mathiasbynens.be/) and dual-licensed under the MIT
and GPL licenses.

You don’t have to do anything special to choose one license or the other and
you don’t have to notify anyone which license you are using. You are free to
re-use parts of this code in commercial projects as long as the copyright
header (as mentioned in `GPL-LICENSE.txt` and `MIT-LICENSE.txt`) is left
intact.