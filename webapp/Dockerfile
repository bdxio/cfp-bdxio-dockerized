# DOCKER-VERSION 0.10.0
FROM        ubuntu:14.04

# Pre-requisites
RUN         apt-get update -y
RUN         apt-get upgrade -y
RUN         apt-get install -y software-properties-common curl git gdebi-core unzip zip

# Java 8
RUN         add-apt-repository -y ppa:webupd8team/java
RUN         apt-get update -y
RUN         echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN         apt-get install -y oracle-java8-installer

# Play2 & SBT
WORKDIR     /tmp
RUN         wget http://dl.bintray.com/sbt/debian/sbt-0.13.2.deb -O /tmp/sbt-0.13.2.deb >/dev/null
RUN         gdebi -n /tmp/sbt-0.13.2.deb >/dev/null
RUN         rm -f sbt-0.13.2.deb
RUN         wget http://downloads.typesafe.com/play/2.2.0/play-2.2.0.zip -O /tmp/play-2.2.0.zip > /dev/null
RUN         unzip play-2.2.0.zip
RUN         rm -f play-2.2.0.zip
RUN         mv /tmp/play-2.2.0 /play2
ENV         PATH /play2:$PATH

# Application
ADD         cfp-devoxx-fr/ /cfp-src/
WORKDIR     /cfp-src/
RUN         sbt update
RUN         play compile stage

# Replacing some application.conf values with redis/elasticsearch ip/port in cfp's jar file
# Note : This should be made during run, not during build (we don't have the variables during build)
ADD         run.sh /cfp-src/run.sh
RUN         chmod a+x run.sh

EXPOSE      9000

ENTRYPOINT  [ "./run.sh" ]
