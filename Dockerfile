FROM ubuntu:14.04
MAINTAINER william.k.krause@gmail.com

RUN locale-gen en_US.UTF-8
RUN apt-get update -q
RUN apt-get install -y build-essential libicu-dev libboost1.54-all-dev\
            libboost-regex1.54-dev libboost-regex-dev libboost-system-dev\
            libboost-program-options-dev libboost-thread-dev zlib1g-dev\
            automake autoconf libtool wget python3-dev swig

WORKDIR /tmp
RUN wget https://s3.amazonaws.com/freeling.image.31/freeling-3.1.source.tar.gz
RUN mkdir /tmp/freeling-3.1
RUN tar xvzf freeling-3.1.source.tar.gz -C /tmp/freeling-3.1
WORKDIR /tmp/freeling-3.1
RUN aclocal; libtoolize; autoconf; automake -a
RUN ./configure
RUN make
RUN make install

WORKDIR /tmp/freeling-3.1/APIs/python
RUN ls -la
RUN make
RUN rm -rf /tmp/freeling-3.1.source

EXPOSE 50005
ENV FREELINGSHARE /usr/local/share/freeling
CMD echo 'Hello world' | analyze -f $FREELINGSHARE/config/en.cfg | grep -c 'world world NN 1'
