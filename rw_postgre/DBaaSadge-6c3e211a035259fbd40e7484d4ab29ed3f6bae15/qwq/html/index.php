<?php
error_reporting(0);

if(!$sql=(string)$_GET["sql"]){
  show_source(__FILE__);
  die();
}

header('Content-Type: text/plain');

if(strlen($sql)>100){
  die('That query is too long ;_;');
}

if(!pg_pconnect('dbname=postgres user=realuser')){
  die('DB gone ;_;');
}

if($query = pg_query($sql)){
  print_r(pg_fetch_all($query));
} else {
  die('._.?');
}
