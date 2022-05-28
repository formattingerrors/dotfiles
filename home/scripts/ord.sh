#!/bin/sh

input=$1
ord(){
	local num=$1
	if [[ "$num" -eq 0 ]]; then
		echo -n Ø;
	else
		sneed="$((num-1))"
		num_1=$(ord sneed)
		echo -n "$num_1,{$num_1}"
	fi
}

echo -n '{'
ord "$((input-1))"
echo '}'
