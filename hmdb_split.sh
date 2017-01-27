#!/bin/bash

# Author: Kiyoon Kim (yoonkr33@gmail.com)
# Description: Split(Copy) HMDB51 dataset with provided Three Splits text files.

if [ $# -lt 3 ]
then
	echo "Usage: $0 [Three Splits directory] [Dataset location] [Output directory]"
	echo "Split(Copy) HMDB51 dataset with provided Three Splits text files."
	echo "Author: Kiyoon Kim (yoonkr33@gmail.com)"
	exit 0
fi

split_dir=$(realpath "$1")
data_dir=$(realpath "$2")

mkdir -p "$3"
out_dir=$(realpath "$3")

classes=$(find "$data_dir" -mindepth 1 -maxdepth 1 -type d)
if [ $(echo "$classes" | wc -l) -ne 51 ]
then
	echo "Error: dataset contains less or more than 51 classes." 1>&2
	exit 1
fi
echo "$classes" | while read line
do
	name=$(basename "$line")

	for i in {1..3}
	do
		mkdir -p "$out_dir/train$i/$name"
		mkdir -p "$out_dir/val$i/$name"
		file_content=$(cat "$split_dir/${name}_test_split${i}.txt")

		file=$(echo "$file_content" | grep ' 1 $' | awk '{print $1}')
		if [ $(echo "$file" | wc -l) -ne 70 ]
		then 
			echo "Error: $split_dir/${name}_test_split${i}.txt doesn't consist 70 training data." 1>&2
		fi
		echo "$file" | xargs -i cp "$data_dir/$name/{}" "$out_dir/train$i/$name"

		file=$(echo "$file_content" | grep ' 2 $' | awk '{print $1}')
		if [ $(echo "$file" | wc -l) -ne 30 ]
		then 
			echo "Error: $split_dir/${name}_test_split${i}.txt doesn't consist 70 training data." 1>&2
		fi
		echo "$file" | xargs -i cp "$data_dir/$name/{}" "$out_dir/val$i/$name"
	done
done	
