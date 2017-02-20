<?php
// Creates a CSV of files under $BASE, includes metadata: mtime, ctime, size, sha512
//
// TODO: 
// - currently saves CSV extremely inefficiently
// - add argv 
// -- trigger debug console output instad of always
// -- input/output files
// -- BASE
// - error handle all the things!
// - return code all the things!

$BASE = ".";

$fp = fopen("filelist.csv","w");
fwrite($fp,"file,mtime,ctime,size,hash\n");

function dirrunner($objparent) 
{
	GLOBAL $fp;
	echo "DIR: $objparent\n";
	foreach (glob("$objparent/*") as $obj) {
		if (is_dir("$obj")) {
			//if ("$obj" == '.' || $obj == '..' || $obj == "$objparent") continue;
			dirrunner("$obj");
		}
		else {
				$stat = stat("$obj");
				$hash = hash_file('sha512', "$obj");
				$str = "\"$obj\",\"" . $stat['mtime'] . "\",\"" . $stat['ctime'] . "\",\"" . $stat['size'] . "\",\"$hash\"\n";
				echo "FILE: $str\n";
				fwrite($fp, $str);
		}
	}
}

foreach (glob("$BASE/*") as $obj) dirrunner("$obj");

fclose($fp);
?>