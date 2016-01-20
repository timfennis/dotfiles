<?php

$output = [];

exec(
	"dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'",
	$output
);

$output = implode('', $output);
// $output = preg_replace('/\s+/', '', $output);

//xesam:artist"variantarray[string"Muffler"
//xesam:title"variantstring"Rock"

$matches = [];

// var_dump($output);

preg_match("#xesam:artist\"\s*variant\s*array\s*\[\s*string\s*\"([^\"]*)\"#", $output, $matches);
$artist = $matches[1];

preg_match("#xesam:title\"\s*variant\s*string\s*\"([^\"]*)\"#", $output, $matches);
$title = $matches[1];

$title = str_replace('&', 'and', $title);
$artist = str_replace('&', 'and', $artist);

echo "$artist - $title";
// var_dump($output);
