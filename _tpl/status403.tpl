<?php
header('HTTP/1.1 403 Forbidden');
require('head.tpl');
?>
<h1>403 Forbidden</h1>
<p>You don’t have permission to view this document.</p>
<?php $ga = true; require('foot.tpl'); ?>