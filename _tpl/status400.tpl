<?php
header('HTTP/1.1 400 Bad Request');
require('head.tpl');
?>
<h1>400 Bad Request</h1>
<p>The request cannot be fulfilled due to bad syntax.</p>
<?php $ga = true; require('foot.tpl'); ?>