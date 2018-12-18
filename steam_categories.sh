#!/bin/bash

rm -rf /var/tmp/steamy_cats/
mkdir /var/tmp/steamy_cats/

# Reads from a filename passed to it
# No arguments available, just outputs something Bash can handle instead of VDF

BEGIN_APPS=$(grep -n \"Apps\" "$1" | cut -d: -f1)
END_APPS=$(grep -n $'^\t\t\t\t}' "$1" | cut -d: -f1 | head -n1)

let COUNT_LINES=END_APPS-BEGIN_APPS

# Moving the values slightly, so we skip the brackets
let END_APPS=END_APPS-1
let COUNT_LINES=COUNT_LINES-2

PREV_LINE=0
for i in $(head -n "$END_APPS" "$1" | tail -$COUNT_LINES | grep -n $'^\t\t\t\t\t\"' | cut -d: -f1)
do
	let START_SPOT=$i+$BEGIN_APPS
	let END_SPOT=$i-$PREV_LINE
	head -n "$START_SPOT" "$1" | tail -"$END_SPOT" > /var/tmp/steamy_cats/"$PREV_LINE"
	PREV_LINE=$i
done

# Catching the last game, since the for loop cannot
let END_SPOT=$END_APPS-$i-$BEGIN_APPS
head -n "$END_APPS" "$1" | tail -"$END_SPOT" > /var/tmp/steamy_cats/"$PREV_LINE"

# Removing the file that can't possibly have anything in it
rm /var/tmp/steamy_cats/0