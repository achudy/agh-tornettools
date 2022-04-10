#!/bin/bash
#Shadow
git clone https://github.com/shadow/shadow.git
cd shadow
./setup build --clean --test
./setup test
./setup install
cd ..

#Oniontracetools
apt install -y python python-dev python-pip python-virtualenv libxml2 libxml2-dev libxslt1.1 libxslt1-dev libpng16-16 libpng16-16 libfreetype6 libfreetype6-dev libblas-dev liblapack-dev
git clone https://github.com/shadow/oniontrace.git
cd oniontrace
sudo apt-get install cmake libglib2.0-0 libglib2.0-dev -y
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/.local
make
make install
cd ../..

#TgenTools
apt install -y  python3 python3-dev python3-pip python3-venv libxml2 libxml2-dev libxslt1.1 libxslt1-dev libpng16-16 libpng-dev libfreetype6 libfreetype6-dev libblas-dev liblapack-dev
sudo apt-get install cmake libglib2.0-0 libglib2.0-dev libigraph1 libigraph-dev -y
git clone https://github.com/shadow/tgen.git
cd tgen
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/.local
make
make install
cd ../..


#Tornettools
wget https://collector.torproject.org/archive/relay-descriptors/consensuses/consensuses-2020-11.tar.xz
wget https://collector.torproject.org/archive/relay-descriptors/server-descriptors/server-descriptors-2020-11.tar.xz
wget https://metrics.torproject.org/userstats-relay-country.csv
wget https://collector.torproject.org/archive/onionperf/onionperf-2020-11.tar.xz
wget -O bandwidth-2020-11.csv "https://metrics.torproject.org/bandwidth.csv?start=2020-11-01&end=2020-11-30"
tar xaf consensuses-2020-11.tar.xz
tar xaf server-descriptors-2020-11.tar.xz
tar xaf onionperf-2020-11.tar.xz
git clone https://github.com/tmodel-ccs2018/tmodel-ccs2018.github.io.git
apt install -y openssl libssl-dev libevent-dev build-essential automake zlib1g zlib1g-dev
git clone https://git.torproject.org/tor.git
cd tor
./autogen.sh
./configure --disable-asciidoc --disable-unittests --disable-manpage --disable-html-manual
make -j$(nproc)
cd ..
export PATH=${PATH}:`pwd`/tor/src/core/or:`pwd`/tor/src/app:`pwd`/tor/src/tools
tornettools stage \
	consensuses-2020-11 \
	server-descriptors-2020-11 \
	userstats-relay-country.csv \
	tmodel-ccs2018.github.io \
	--onionperf_data_path onionperf-2020-11 \
	--bandwidth_data_path bandwidth-2020-11.csv \
	--geoip_path tor/src/config/geoip
