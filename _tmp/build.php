<?php

error_reporting(E_ALL);

if (!function_exists('http_parse_headers')) {
	function http_parse_headers($header) {
		$retVal = array();
		$fields = explode("\r\n", preg_replace('/\x0D\x0A[\x09\x20]+/', ' ', $header));
		foreach($fields as $field) {
			if (preg_match('/([^:]+): (.+)/m', $field, $match)) {
				$match[1] = preg_replace('/(?<=^|[\x09\x20\x2D])./e', 'strtoupper("\0")', strtolower(trim($match[1])));
				if (isset($retVal[$match[1]])) {
					$retVal[$match[1]] = array($retVal[$match[1]], $match[2]);
				} else {
					$retVal[$match[1]] = trim($match[2]);
				}
			}
		}
		return $retVal;
	}
}

function minify($code) {
	$ch = curl_init('http://refresh-sf.com/yui/');
	curl_setopt($ch, CURLOPT_POST, 1);
	curl_setopt($ch, CURLOPT_POSTFIELDS, array(
		'compresstext' => $code,
		'semi' => 'on',
		'redirect' => 'on'
	));
	curl_setopt($ch, CURLOPT_HEADER, true);
// curl_setopt($ch, CURLOPT_NOBODY, true);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	$result = curl_exec($ch);
	$result = http_parse_headers($result);
	$location = 'http://refresh-sf.com' . $result['Location'];
	curl_close($ch);
	$result = file_get_contents($location);
	return strpos($result, '[ERROR]') ? $code : $result;
}

if (isset($_POST['code'])) {
	header('Content-Type: text/plain;charset=UTF-8');
	$convert = array(
/*
		'1000000'       => '1e6',
		'3000'          => '3e3',
		'2000'          => '2e3',
		'1000'          => '1e3',
		':0.'           => ':.',
*/
		'&hellip;'      => '…',
		'&times;'       => '×',
		'&infin;'       => '∞',
		'&plusmn;'      => '±',
		'\u03b1'        => 'α',
		'\u03b2'        => 'β'
	);
	$output = rtrim(str_replace(array_keys($convert), array_values($convert), trim($_POST['code'], ';')), ';');
	file_put_contents('../_js/benchmark.js', $output);
	$file = '/home/jsperf_com/public_html/_inc/version.txt';
	$v = (int) file_get_contents($file) + 1;
	file_put_contents($file, $v);
	mail(ADMIN_EMAIL, '[jsPerf] Deployed Benchmark.js revision ' . $v, 'Deployed Benchmark.js revision ' . $v);
	echo $output;
} else {
	header('Content-Type: text/html;charset=UTF-8');
	$convert = array(
		'gaId = \'\'' => 'gaId = \'UA-6065217-40\'',
		'if (freeExports)' => 'if (false)',
		'\'selector\': \'\'' => '\'selector\': \'#bs-results\'',
		'archive = \'../../nano.jar\'' => 'archive = \'/_jar/nano.jar\''
	);
	$_SESSION['admin'] = true;
	$files = array(
		'bestiejs/platform.js/master/platform.js' => array('dest' => 'platform.src.js', 'source' => ''),
		'bestiejs/benchmark.js/master/benchmark.js' => array('dest' => 'benchmark.src.js', 'source' => ''),
		'bestiejs/benchmark.js/master/example/jsperf/ui.js' => array('dest' => 'ui.src.js', 'source' => ''),
		'bestiejs/benchmark.js/master/plugin/ui.browserscope.js' => array('dest' => 'ui.browserscope.src.js', 'source' => '')
	);
	$source = '';
	foreach($files as $file => $arr) {
		$files[$file]['source'] = str_replace(array_keys($convert), array_values($convert), preg_replace('/(if\s*\()(typeof define|freeDefine)\b/', '$1false', file_get_contents('https://raw.github.com/' . $file)));
		file_put_contents('../_js/' . $arr['dest'], $files[$file]['source']);
		$source .= "\n\n" . $files[$file]['source'];
	}
	$source = minify(trim($source));
?>
<!DOCTYPE html><title>Deploy Benchmark.js</title><style>textarea{width:100%;height:40em;font-family:Consolas}</style><form method=post><textarea name=code autofocus><?php echo he($source); ?>
</textarea><input type=submit value=deploy></form>
<?php } ?>