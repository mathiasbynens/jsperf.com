<?php
header('Content-Type: text/plain;charset=UTF-8');
if (!isset($_SESSION['admin'])) {
 header('Location: http://' . DOMAIN . '/' . $slug, null, 301);
 @mail(ADMIN_EMAIL, '[jsPerf] Delete hax?', $_SERVER['REMOTE_ADDR'] . ' accessed /' . $slug . '/delete');
 die('hax‽');
}
// TODO: mail all details before removing page?
if ($rev > 1) {
 // Delete only one revision
 if ($db->query('DELETE FROM tests WHERE pageID IN (SELECT id FROM pages WHERE slug = "' . $db->real_escape_string($slug) . '" AND revision = ' . $rev . ')') && $db->query('DELETE FROM pages WHERE slug = "' . $db->real_escape_string($slug) . '" AND revision = ' . $rev)) {
  die('Revision ' . $rev . ' deleted');
 } else {
  die('Couldn’t delete');
 }
} else {
 // Delete all revisions of this test case
 if ($db->query('DELETE FROM tests WHERE pageID IN (SELECT id FROM pages WHERE slug = "' . $db->real_escape_string($slug) . '")') && $db->query('DELETE FROM pages WHERE slug = "' . $db->real_escape_string($slug) . '"')) {
  die('Deleted');
 } else {
  die('Couldn’t delete');
 }
}
?>