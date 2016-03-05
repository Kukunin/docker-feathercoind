FROM armv7/armhf-ubuntu_core:14.04
MAINTAINER Sergiy Kukunin <sergiy.kukunin@gmail.com>

RUN apt-get update && \
    apt-get install -y wget build-essential libtool autotools-dev autoconf libssl-dev git-core libminiupnpc-dev pkg-config \
                            libboost-dev libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz && \
    tar -xzvf db-4.8.30.NC.tar.gz && \
    cd db-4.8.30.NC/build_unix && \
    ../dist/configure --enable-cxx --prefix=/usr && \
    make -j4 && \
    sudo make install && \
    cd ../.. && rm -rf db-4.8.30.NC db-4.8.30.NC.tar.gz

RUN cd /opt && \
    wget https://github.com/FeatherCoin/Feathercoin/archive/master-0.8.tar.gz -O feathercoin.tar.gz && \
    tar -xvf feathercoin.tar.gz && \
    mv Feathercoin-master-0.8 feathercoin && \
    cd feathercoin/src && \
    USE_UPNP=1 make -f makefile.unix && \
    cp /opt/feathercoin/src/feathercoind /usr/local/bin/ && \
    rm -rf /opt/feathercoin*

RUN groupadd -r feathercoin && useradd -r -m -g feathercoin feathercoin

ENV FEATHERCOIN_DATA /data

RUN mkdir $FEATHERCOIN_DATA && \
    chown feathercoin:feathercoin $FEATHERCOIN_DATA && \
    ln -s $FEATHERCOIN_DATA /home/feathercoin/.feathercoin

USER feathercoin
VOLUME /data

EXPOSE 9336 9337

CMD ["/usr/local/bin/feathercoind", "-printtoconsole"]
