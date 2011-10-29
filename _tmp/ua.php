<?php
header('Content-Type: text/plain;charset=UTF-8');
if (mail(ADMIN_EMAIL, $_SERVER['HTTP_USER_AGENT'], $_SERVER['HTTP_USER_AGENT'])) {
 echo $_SERVER['HTTP_USER_AGENT'];
}
?>