<?php $db->close(); ?>
</article>
<footer><a href="/">Add test</a> · <?php
if (isset($_SESSION['authorSlug'])) {
  ?><a href="/browse/<?php echo $_SESSION['authorSlug']; ?>">My tests</a> · <?php
} ?><a href="/browse">Latest</a> · <a href="/popular">Popular</a> · <a href="/faq">FAQ</a> · <a href="/faq#donate">Donate</a> · <a href="//twitter.com/jsprf" rel="nofollow">twitter: @jsprf</a> · <a href="https://github.com/mathiasbynens/jsperf.com">source on GitHub</a> · <a href="//benchmarkjs.com/">Benchmark.js</a> · by <a href="//mathiasbynens.be/">@mathias</a> and <a href="/contributors">contributors</a></footer>
<?php if ($benchmark) { if ($debug) { ?>
<script src="//<?php echo ASSETS_DOMAIN; ?>/_js/platform.src.js"></script>
<script src="//<?php echo ASSETS_DOMAIN; ?>/_js/benchmark.src.js"></script>
<script src="//<?php echo ASSETS_DOMAIN; ?>/_js/ui.src.js"></script>
<script src="//<?php echo ASSETS_DOMAIN; ?>/_js/ui.browserscope.src.js"></script>
<?php
} else { ?>
<script src="//<?php echo ASSETS_DOMAIN; ?>/benchmark-<?php echo file_get_contents('_inc/version.txt'); ?>.js"></script><?php
}
if (isset($item->scripts)) {
  echo "\n" . implode("\n", $item->scripts) . (count($item->scripts) ? "\n" : '');
}
?>
<script>
<?php if ($item->browserscopeID) { ?>
  ui.browserscope.key = '<?php echo $item->browserscopeID; ?>';

<?php } ?>
  ui<?php
foreach ($tests as $index => $test) {
  echo $index ? ")\n  " : '';
?>
.add('<?php echo addslashes(removeBackticks($test->title)); ?>', <?php
  if ('y' == $test->defer) {
    ?>{
    'defer': true,
    'fn': <?php
    echo "'\\\n      " . preg_replace('/[\r\n]{1,2}/', "\\n\\\n      ", addslashes($test->code)) . "'\n" ?>  }<?php
  } else {
    ?>'<?php
    echo "\\\n    " . preg_replace('/[\r\n]{1,2}/', "\\n\\\n    ", addslashes($test->code));
    ?>'<?php
	echo "\n  ";
  }
}
?>);
<?php
echo ($item->setup ? "\n  Benchmark.prototype.setup = '\\\n    " . preg_replace('/[\r\n]{1,2}/', "\\n\\\n    ", addslashes($item->setup)) . "';\n" : '');
echo ($item->teardown ? "\n  Benchmark.prototype.teardown = '\\\n    " . preg_replace('/[\r\n]{1,2}/', "\\n\\\n    ", addslashes($item->teardown)) . "';\n" : '')
?>
</script>
<?php
} else if ($mainJS) { ?>
<?php flush(); ?>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.js"></script>
<?php if ($debug) { ?>
<script src="//<?php echo ASSETS_DOMAIN; ?>/beautify.js"></script>
<script src="//<?php echo ASSETS_DOMAIN; ?>/main.src.js"></script>
<?php } else { ?>
<script src="//<?php echo ASSETS_DOMAIN; ?>/main-111009.js"></script>
<?php } ?>
<?php } else if ($ga) { ?>
<script>var _gaq=[['_setAccount','UA-6065217-40'],['_trackPageview']];(function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];g.src='//www.google-analytics.com/ga.js';s.parentNode.insertBefore(g,s)}(document,'script'))</script>
<?php } ?>
</body>
</html>