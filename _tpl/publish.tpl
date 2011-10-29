<?php

if ($item->visible === 'n' && (isset($_SESSION['own'][$item->id]) || isset($_SESSION['admin']))) {
 $sql = 'UPDATE pages SET visible = "y" WHERE id = ' . $item->id;
 if ($db->query($sql)) {
  header('Location: http://' . DOMAIN . '/' . $slug . ($item->revision > 1 ? '/' . $item->revision : ''), null, 301);
 } else {
  header('Content-Type: text/plain;charset=UTF-8');
  die('Couldn’t publish');
 }
}

header('Location: http://' . DOMAIN . '/' . $slug . ($item->revision > 1 ? '/' . $item->revision : ''), null, 301);

?>