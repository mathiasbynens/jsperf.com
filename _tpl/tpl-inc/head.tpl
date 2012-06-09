<?php

// http://crbug.com/85454
if (isset($item)) {
	header('X-XSS-Protection: 0');
}

?>
<!DOCTYPE html>
<html lang="en"<?php if ($embed) { ?> class="embed"<?php } ?>>
<head>
<meta charset="utf-8">
<title><?php if (isset($title)) { ?><?php echo removeBackticks(he($title)); ?> · jsPerf<?php } else { ?>jsPerf: JavaScript performance playground<?php } ?></title>
<?php if ($home) { ?>
<meta name="description" content="A performance playground for JavaScript developers. Easily create and share test cases and run cross-browser benchmarks to find out which code snippet is most efficient.">
<?php } else if ($showAtom && isset($item) && '' !== trim($item->info)) { ?>
<meta name="description" content="<?php echo trim(shorten(strip_tags(str_replace(array('"', "\n"), array('&quot;', ' '), md($item->info))))); ?>">
<?php } else if ($noIndex) { ?>
<meta name="robots" content="noindex">
<?php } ?>
<link rel="stylesheet" href="http://<?php echo DOMAIN; /* don’t use ASSETS_DOMAIN here in case the CSS will be XHRed */ ?>/_css/<?php echo $debug ? 'main.src' : '111220'; ?>.css<?php echo $debug ? '?' . time() : ''; ?>">
<?php if ($home) { ?>
<link href="/browse.atom" rel="alternate" type="application/atom+xml" title="Atom feed for new or updated test cases">
<?php } else if ($author) { ?>
<link href="/browse/<?php echo $author; ?>.atom" rel="alternate" type="application/atom+xml" title="Atom feed for test cases by this author">
<?php } else if ($search) { ?>
<link href="/search.atom?q=<?php echo urlencode($search); ?>" rel="alternate" type="application/atom+xml" title="Atom feed for test cases about <?php echo he($search); ?>">
<?php } else if ($showAtom) { ?>
<link href="/<?php echo $slug; ?>.atom" rel="alternate" type="application/atom+xml" title="<?php echo ($slug == 'browse' ? 'Atom feed for new or updated test cases' : 'Atom feed for revisions of this test case'); ?>">
<?php } ?>
<?php if ($jsClass) { ?>
<script>document.documentElement.className='js'</script>
<?php } ?>
<!--[if lt IE 9]><script src="//<?php echo ASSETS_DOMAIN; ?>/html5.js"></script><![endif]-->
</head>
<?php flush(); ?>
<body>
<article>
