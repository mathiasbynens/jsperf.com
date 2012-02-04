<?php

if (!isset($_SESSION['admin'])) {
	include('status404.tpl');
	@mail(ADMIN_EMAIL, '[jsPerf] Edit comment hax?', $_SERVER['REMOTE_ADDR'] . ' accessed /edit-comment/' . $id);
} else {
	if (!empty($_POST)) {
		$sql = 'UPDATE comments SET author = "' . $db->real_escape_string($_POST['author']) . '", authorEmail = "' . $db->real_escape_string($_POST['author-email']) . '", authorURL = "' . $db->real_escape_string($_POST['author-url']) . '", content = "' . $db->real_escape_string($_POST['message']) . '" WHERE id = ' . $id;
		if ($db->query($sql)) {
			die('Comment updated.');
		}
	} else {
		if ($result = $db->query('SELECT * FROM comments WHERE id = ' . $id)) {
			if ($result && $result->num_rows > 0) {
				$r = $result->fetch_object();
				include('head.tpl');
?>
<h1>Edit a comment</h1>
<form action="" method="post">
	<fieldset>
		<div><label for="author">Name <em title="This field is required">*</em> </label><input type="text" name="author" id="author" value="<?php echo he($r->author); ?>" required></div>
		<div><label for="author-email">E-mail <em title="This field is required">*</em> </label><input type="email" name="author-email" id="author-email" value="<?php echo he($r->authorEmail); ?>" required></div>
		<div><label for="author-url">URL </label><input type="url" name="author-url" id="author-url" value="<?php echo he($r->authorURL); ?>"></div>
		<div><label for="message">Message <em title="This field is required">*</em> <span>Markdown syntax is allowed</span></label><textarea id="message" name="message" required><?php echo he($r->content); ?></textarea></div>
		<div class="buttons"><input type="submit" class="submit" value="Update comment"></div>
	</fieldset>
</form>
<pre><?php print_r($r); ?></pre>
<?php
				include('foot.tpl');
			} else {
				die('Couldn’t retrieve comment.');
			}
		} else {
			die('Couldn’t retrieve comment.');
		}
	}
}
?>