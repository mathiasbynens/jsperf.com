<?php flush(); ?>
<section id="comments"><h1><?php
echo (count($comments) == 1 ? '1 comment' : count($comments) . ' comments');
?></h1><div id="comments-wrapper"><?php

foreach ($comments as $i => $comment) {
	$owner = false;
	?><article id="comment-<?php echo $i + 1; ?>"<?php
	if ($comment->author === $item->author && $comment->authorEmail === $item->authorEmail && $comment->authorURL === $item->authorURL) {
		$owner = true;
		?> class="owner"<?php
	}
	?>><p class="meta"><img src="//gravatar.com/avatar/<?php echo md5($comment->authorEmail); ?>?s=26" width="26" height="26"> <?php
	echo author($comment->author, $comment->authorURL, true);
	if ($owner) {
		?> (revision owner)<?php
	}
	?> commented <time datetime="<?php echo date('c', strtotime($comment->published));
	?>" pubdate><?php echo relativeDate($comment->published);
	?></time>: <a href="<?php echo $location->href . '#comment-' . $i;
	?>" title="Permanent link to this comment">∞</a><?php

	if (isset($_SESSION['admin'])) {
		?><a href="<?php echo $location->origin . '/edit-comment/' . $comment->id; ?>">edit</a><?php
	}
	?></p><div><?php
	echo md($comment->content);
	?></div></article><?php
}
flush();
?>
<form action="<?php echo $location->href ?>#comment-form" method="post" id="comment-form">
	<fieldset>
		<h2>Add a comment</h2>
		<div><label for="author">Name <em title="This field is required">*</em> </label><input type="text" name="author" id="author"<?php
		if ($author) {
			echo ' value="' . he($author) . '"';
		}
		?> required><?php
		if ($nameError) {
			echo ' ' . $nameError;
		}
		?></div>
		<div><label for="author-email">Email <em title="This field is required">*</em> </label><?php
		if (!$mailError) {
			?><label class="inline"><?php
		}
		?><input type="email" name="author-email" id="author-email"<?php
		if ($authorEmail) {
			echo ' value="' . he($authorEmail) . '"';
		}
		?> required><?php
		if ($mailError) {
			echo ' ' . $mailError;
		} else {
			?> (only used for Gravatar)</label><?php
		}
		?></div>
		<div><label for="author-url">URL </label><input type="url" name="author-url" id="author-url"<?php
		if ($authorURL) {
			echo ' value="' . he($authorURL) . '"';
		}
		?>></div>
		<div><label for="message">Message <em title="This field is required">*</em> <span>Markdown syntax is allowed</span></label><?php
		epv('message', true, false, true);
		if ($msgError) {
			echo ' ' . $msgError;
		}
		?></div>
		<div class="question"><label for="question">Are you a spammer? <span>(just answer the question)</span> </label><input type="text" <?php
		epv('question');
		?>><?php
		if ($spamError) {
			echo ' ' . $spamError;
		}
		?></div>
		<div class="buttons"><input type="submit" class="submit" value="Add comment"></div>
	</fieldset>
</form>
</div>
</section>