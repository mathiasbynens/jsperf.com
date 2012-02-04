<?php
if (!isset($_SESSION['admin'])) {
	include('status404.tpl');
	@mail(ADMIN_EMAIL, '[jsPerf] Delete comment hax?', $_SERVER['REMOTE_ADDR'] . ' accessed /delete-comment/' . $id);
} else {
	header('Content-Type: text/plain;charset=UTF-8');
	// TODO: mail all details before removing comment?
	if ($db->query('DELETE FROM comments WHERE id = ' . $id)) {
		die('Deleted');
	} else {
		die('Couldn’t delete');
	}
}
?>