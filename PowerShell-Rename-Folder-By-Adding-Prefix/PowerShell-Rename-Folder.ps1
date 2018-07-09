# This script rename folder by adding prefix ex- before folder name
$from = "D:\Users2\mihailovrs\Desktop\backup\rename"
$before = Split-Path $from # Split path
$before 
$after = Split-Path -Leaf $from # Separate only last folder
$after
$newpath = $before + "\ex-" + $after # Concatinate to get new name like ex-folder
$newpath
Rename-Item $from $newpath # Start rename

