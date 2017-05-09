#!/bin/bash

function bkv::__validate_key () {
	if [ -n $(echo $1 | grep -E '[a-zA-Z0-9]+') ]; then
		echo $1
	else
		echo "INVALID KEY: $1" 1>&2
		echo '__ERROR_KEY'
	fi
}

function bkv::set_value () {
	FILE=$1
	KEY=$(bkv::__validate_key $1)
	VALUE=$(sed 's/=/==/g' $3)
	PRESENT=$(bkv::is_set $KEY)
	
	# Remove it from the file if necessary.
	if [ "$PRESENT" == 'true' ]; then
		sed -i "s/^$KEY=.*//g" $FILE
	fi
	
	# Append the value
	echo "$KEY=$VALUE" >> $FILE
}

function bkv::get_value () {
	FILE=$1
	KEY=$(bkv::__validate_key $1)
	
	# Look for the line then pull out the prefix.
	grep "^$KEY=" $FILE | sed "s/^$KEY=//"
}

function bkv::is_set () {
	FILE=$1
	KEY=$(bkv::__validate_key $1)
	
	# Here we just see if any lines match the regex for what we expect.
	if [ -n $(grep -E "^$KEY=([^=]|==)*" $FILE) ]; then
		echo 'true'
	else
		echo 'false'
	fi
}

