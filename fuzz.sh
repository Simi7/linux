#!/bin/bash

if [[ $1 == *".cpp" ]] || [[ $# -ge 1 ]]; then
	#Building libFuzzer Executables
	clang++ -fsanitize=address,fuzzer ./$1 -o ./fuzzed
	#Running libFuzzer Executables
	./fuzzed ${@:2}
else
	#Handling an invalid arguments input
	echo "Invalid argument"
	exit -1
fi
