FROM ubuntu:24.04
MAINTAINER Jeremy Elder <jeremy@d0xed.com>

RUN apt-get update && apt-get install -y \
bison \
flex \
libssl-dev \
build-essential \
wget \
supervisor \
git \
pkg-config

RUN groupadd -r ircd && \
useradd -r -u 1001 -d /opt/charybdis -g ircd ircd
RUN mkdir /opt/charybdis
RUN mkdir opt/atheme

WORKDIR /root
RUN wget https://github.com/charybdis-ircd/charybdis/archive/charybdis-3.5.5.tar.gz && \
mkdir charybdis-build && \
tar xfz charybdis-3.5.5.tar.gz -C charybdis-build
RUN cd charybdis-build/* && \
./configure --prefix=/opt/charybdis/ && \
make && \
make install

WORKDIR /root
RUN git clone https://github.com/atheme/atheme.git atheme-devel
RUN cd atheme-devel
WORKDIR /root/atheme-devel
RUN git checkout atheme-7.2.12
RUN git submodule update --init
RUN ./configure --enable-contrib --prefix=/opt/atheme/ --disable-nls && \
make && \
make install


ENV PATH=/opt/charybdis/bin:/opt/atheme/bin/:$PATH

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ircd.conf /opt/charybdis/etc/ircd.conf
COPY atheme.conf /opt/atheme/etc/atheme.conf


RUN chown -R ircd:ircd /opt/atheme
RUN chown -R ircd:ircd /opt/charybdis

RUN rm -rf /root/atheme-devel
RUN rm -rf /root/charybdis-build

CMD ["/usr/bin/supervisord"]
