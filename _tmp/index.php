<?php
header('Content-Type: text/plain;charset=UTF-8');
$_SESSION['admin'] = true;

$testCases = $db->query('SELECT COUNT(id) AS count FROM pages')->fetch_object()->count;
$tests = $db->query('SELECT COUNT(testID) AS count FROM tests')->fetch_object()->count;
$comments = $db->query('SELECT COUNT(id) AS count FROM comments')->fetch_object()->count;
?>
You now have magical admin powers! ◔◡◔

<?php
$days = floor((time() - strtotime('August 1, 2010')) / 86400);
echo 'jsPerf is ' . number_format($days) . ' days old.
' . number_format($testCases) . ' test cases (that’s ~' . number_format($testCases / $days, 2) . ' per day)
' . number_format($tests) . ' tests (that’s ~' . number_format($tests / $testCases, 2) . ' per test case)
' . number_format($comments) . ' comments (that’s ~' . number_format($comments / $testCases, 2) . ' per test case or ~' . number_format($comments / $days, 2) . ' per day)';
?>