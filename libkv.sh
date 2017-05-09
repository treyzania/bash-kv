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
	touch $FILE
	KEY=$(bkv::__validate_key $2)
	VALUE=$(echo $3 | sed 's/=/==/g')
	PRESENT=$(bkv::is_set $KEY)
	
	# Remove it from the file if necessary.
	if [ "$PRESENT" == 'true' ]; then
		sed -i "s/^$KEY=.*//g" $FILE
	fi
	
	# Append the value
	echo "$KEY=$VALUE" >> $FILE

	# Cleanup newlines ( from http://stackoverflow.com/questions/7359527/ )
	sed -e :a -e '/./,$!d;/^\n*$/{$d;N;};/\n$/ba' file
}

function bkv::get_value () {
	FILE=$1
	touch $FILE
	KEY=$(bkv::__validate_key $2)
	
	# Look for the line then pull out the prefix.
	grep "^$KEY=" $FILE | sed "s/^$KEY=//" | sed 's/==/=/g'
}

function bkv::is_set () {
	FILE=$1
	touch $FILE
	KEY=$(bkv::__validate_key $2)
	
	# Here we just see if any lines match the regex for what we expect.
	OUT=$(grep -E "^$KEY=([^=]|==)*" $FILE)
	if [ -n "$OUT" ]; then
		echo 'true'
	else
		echo 'false'
	fi
}

