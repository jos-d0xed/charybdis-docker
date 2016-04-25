FROM ubuntu:14.04
MAINTAINER Jeremy Elder <jeremy@d0xed.com>

RUN apt-get update && apt-get install -y \
bison \
flex \
libssl-dev \
build-essential \
wget \
supervisor

RUN groupadd -r ircd && \
useradd -r -u 1000 -d /opt/charybdis -g ircd ircd
RUN mkdir /opt/charybdis

WORKDIR /root
RUN wget https://github.com/charybdis-ircd/charybdis/archive/charybdis-3.5.1.tar.gz && \
mkdir charybdis-build && \
tar xfz charybdis-3.5.1.tar.gz -C charybdis-build
RUN cd charybdis-build/* && \
./configure --prefix=/opt/charybdis/ --with-topiclen=420 && \
make && \
make install
RUN chown -R ircd:ircd /opt/charybdis
ENV PATH /opt/charybdis/bin:$PATH

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ircd.conf /opt/charybdis/etc/ircd.conf

CMD ["/usr/bin/supervisord"]
