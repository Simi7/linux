#!/bin/bash

#Downloading OpenSSL
curl -O https://ftp.openssl.org/source/old/1.0.1/openssl-1.0.1f.tar.gz
tar xf openssl-1.0.1f.tar.gz
#Building OpenSSL:
cd openssl-1.0.1f/
./config
make CC="clang -g -fsanitize=address,fuzzer-no-link"
cd ..
#Building a libFuzzer Executable
clang++ -g handshake-fuzzer.cc -fsanitize=address,fuzzer \ openssl-1.0.1f/libssl.a openssl-1.0.1f/libcrypto.a \ -std=c++17 -Iopenssl-1.0.1f/include/ -lstdc++fs -ldl -lstdc++ \ -o handshake-fuzzer
curl -O https://raw.githubusercontent.com/google/clusterfuzz/master/docs/setting-up-fuzzing/heartbleed/server.key
curl -O https://raw.githubusercontent.com/google/clusterfuzz/master/docs/setting-up-fuzzing/heartbleed/server.pem
if [[ $# -ge 1 ]]; then
        #Fuzzing and Finding HeartBleed Vulnerability
        ./handshake-fuzzer ${@}
else
        #No argument is given - choosing an arbitrary set of arguments
		./handshake-fuzzer $(< heartbleed.args)
fi
