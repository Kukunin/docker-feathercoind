FROM ubuntu:14.04
MAINTAINER Sergiy Kukunin <sergiy.kukunin@gmail.com>

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8842ce5e && \
    echo "deb http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu trusty main" > /etc/apt/sources.list.d/bitcoin.list

RUN apt-get update && \
    apt-get install -y build-essential libtool autotools-dev autoconf libssl-dev git-core libboost-all-dev libdb4.8-dev libdb4.8++-dev libminiupnpc-dev pkg-config

RUN git clone https://github.com/FeatherCoin/Feathercoin.git /opt/feathercoin && \
    cd /opt/feathercoin && \
    ./autogen.sh && \
    ./configure --with-miniupnpc --enable-upnp-default --disable-tests --without-gui --without-qrcode && \
    make && \
    cp /opt/feathercoin/src/feathercoind /usr/local/bin/ && \
    cp /opt/feathercoin/src/feathercoin-cli /usr/local/bin/ && \
    rm -rf /opt/feathercoin


RUN groupadd -r feathercoin && useradd -r -m -g feathercoin feathercoin

ENV FEATHERCOIN_DATA /data

RUN mkdir $FEATHERCOIN_DATA && \
    chown feathercoin:feathercoin $FEATHERCOIN_DATA && \
    ln -s $FEATHERCOIN_DATA /home/feathercoin/.feathercoin

USER feathercoin
VOLUME /data

EXPOSE 9336 9337

CMD ["/usr/local/bin/feathercoind", "-printtoconsole"]
