<?php

if (isOk('author')) {
	//setcookie('author', $_POST['author'], time() + 60 * 60 * 24 * 30, '/');
	$author = $_POST['author'];
}
if (isOk('author-email')) {
	//setcookie('author-email', $_POST['author-email'], time() + 60 * 60 * 24 * 30, '/');
	$authorEmail = $_POST['author-email'];
}
if (isOk('author-url')) {
	//setcookie('author-url', $_POST['author-url'], time() + 60 * 60 * 24 * 30, '/');
	$authorURL = $_POST['author-url'];
}

if (isOk('author') && isOk('author-email') && isOk('message') && isOk('question') && $_POST['question'] == 'no') {
	$sql = 'INSERT INTO comments (pageID, author, authorEmail, authorURL, content, published, ip) VALUES (' . $item->id . ', "' . $db->real_escape_string($_POST['author']) . '", "' . $db->real_escape_string($_POST['author-email']) . '", "' . $db->real_escape_string($_POST['author-url']) . '", "' . $db->real_escape_string($_POST['message']) . '", NOW(), "' . $db->real_escape_string($_SERVER['REMOTE_ADDR']) . '")';
	if ($db->query($sql)) {
		@mail(ADMIN_EMAIL, '[jsPerf] Comment added to: ' . $item->title, 'http://' . DOMAIN . '/' . $item->slug . ($item->revision > 1 ? '/' . $item->revision : '') . '#comments');
		header('Location: http://' . DOMAIN . '/' . $item->slug . ($item->revision > 1 ? '/' . $item->revision : '') . '#comments');
	}
} else {
	if (!isOk('author')) {
		$nameError = '<span class="error">Please enter your name.</span>';
	}
	if (!isOk('author-email')) {
		$mailError = '<span class="error">Please enter your email address.</span>';
	}
	if (!isOk('message')) {
		$msgError = '<p class="error">Please enter a message.</p>';
	}
	if (!isOk('question') || $_POST['question'] !== 'no') {
		$spamError = '<span class="error">Please enter ‘no’ to prove you’re not a spammer.</span>';
	}
}

// This was just an idea, but it’s probably not a very good one. By extending the $comments array, the additional redirect could be avoided.
// However, I think it’s better to redirect anyway, just in case someone else added another comment while you were writing yours.
/*
$comments[] = (object) array(
	'pageID' => $item->id,
	'author' => $_POST['author'],
	'authorEmail' => $_POST['author-email'],
	'authorURL' => $_POST['author-url'],
	'content' => $_POST['message'],
	'published' => date('Y-m-d H:i:s'),
	'ip' => $_SERVER['REMOTE_ADDR']
);
*/

?>