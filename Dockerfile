FROM centos:latest

MAINTAINER Esa Varemo <esa@kuivanto.fi>

EXPOSE 6543 22


# Install packages
RUN yum update -y
RUN yum install -y wget gcc make gcc openssl-devel sqlite-devel git libffi-devel openssh-server python-setuptools

RUN easy_install pip && pip2 install supervisor


# Install Python3
RUN mkdir /src/
WORKDIR /src/

RUN wget -O - https://www.python.org/ftp/python/3.4.3/Python-3.4.3.tar.xz | xzcat | tar xv

WORKDIR /src/Python-3.4.3/

RUN ./configure && make -j3 && make install -j3
RUN pip3 install --upgrade pip

ADD entrypoint_ssh.sh /entrypoint_ssh.sh

# APPLICATION

ENV APP=displaymanage
ENV USER=$APP
RUN useradd $USER
ENV DIR=/$APP

RUN mkdir $DIR && chown $USER:$USER $DIR
RUN ls -lah /
USER $USER

RUN git clone https://github.com/varesa/displayManage.git $DIR

WORKDIR /$DIR

USER root
RUN pip3 install --allow-external mysql-connector-python -e .
USER $USER

CMD ["pserve", "development.ini"]

VOLUME $DIR
