<?php
header('Content-Type: application/atom+xml;charset=UTF-8');
//TODO Last-Modified: header('Last-Modified: ' . date('r', strtotime($item->updated)));
?>
<feed xmlns="http://www.w3.org/2005/Atom" xml:lang="en">
	<title><?php echo he($item->title); ?></title>
	<subtitle>The latest revisions for this jsPerf test case</subtitle>
	<link rel="self" type="application/atom+xml" href="http://<?php echo DOMAIN; ?>/<?php echo $slug; ?>.atom" />
	<link rel="alternate" type="text/html" href="http://<?php echo DOMAIN; ?>/<?php echo $slug; ?>" />
	<updated><?php echo date('c', strtotime($item->updated)); ?></updated>
	<id>tag:<?php echo DOMAIN; ?>,2010:/<?php echo $item->slug; ?></id>
<?php
foreach ($revisions as $r) { if ($r->visible === 'y') {
?>
	<entry>
		<title><?php echo he($r->title); ?></title>
		<author>
			<name><?php echo he($r->author); ?></name>
		</author>
		<link rel="alternate" type="text/html" href="http://<?php echo DOMAIN; ?>/<?php echo $slug . ($r->revision > 1 ? '/' . $r->revision : ''); ?>" />
		<summary><?php echo ('' == $r->info ? 'No description entered' : he($r->info)); ?></summary>
		<id>tag:<?php echo DOMAIN; ?>,2010:/<?php echo $slug . ($r->revision > 1 ? '/' . $r->revision : ''); ?></id>
		<published><?php echo date('c', strtotime($r->published)); ?></published>
		<updated><?php echo date('c', strtotime($r->updated)); ?></updated>
	</entry>
<?php
} }
?>
</feed>