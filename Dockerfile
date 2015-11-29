FROM registry.esav.fi:5000/python3

MAINTAINER Esa Varemo <esa@kuivanto.fi>

EXPOSE 6543 22

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
