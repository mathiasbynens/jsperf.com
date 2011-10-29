<?php
$e404 = true;
header('HTTP/1.0 404 Not Found');
require('head.tpl');
?>
<h1>404 Not Found</h1>
<p>The requested document could not be found.</p>
<?php $ga = true; require('foot.tpl'); ?>