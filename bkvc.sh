#!/bin/bash

FILE=$1
ACTION=$2

source libkv.sh

if [ "$ACTION" == 'set' ]; then
	bkv::set_value "$FILE" "$3" "$4"
elif [ "$ACTION" == 'get' ]; then
	bkv::get_value "$FILE" "$3"
elif [ "$ACTION" == 'present' ]; then
	bkv::is_set "$FILE" "$3"
fi

