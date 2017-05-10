# Dockerfile for base collectd install

FROM ubuntu:16.04
MAINTAINER Peyton Casper peytoncas@gmail.com

# Install all apt-get utils and required repos
RUN apt-get update && \
    apt-get upgrade -y && \
    # Install add-apt-repository
    apt-get update && \
    # Install
    apt-get install -y \
    software-properties-common\
    # Install pip
    python-pip \
    python-setuptools \
    git \
    zip \
    jq \
    tree \
    apt-transport-https \
    nano

# Make ssh dir
RUN mkdir /root/.ssh/

# Copy over private key, and set permissions
ADD ./id_rsa /root/.ssh/id_rsa

# Create known_hosts
RUN touch /root/.ssh/known_hosts
# Add github key
RUN ssh-keyscan github.org >> /root/.ssh/known_hosts
#RUN ssh-keygen -R github.org

#git stuff
#RUN chmod 700 /root/.ssh/id_rsa
#RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
#RUN git config --global url.ssh://git@github.com/.insteadOf https://github.com/

#clone powertrain 
RUN git clone https://github.com/datastax-demos/PowertrainStreaming.git 
RUN git clone https://github.com/datastax-demos/Powertrain2.git


# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $JAVA_HOME/bin:$PATH

# Install sbt
RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
RUN apt-get update
RUN apt-get install sbt

COPY docker.sh .

EXPOSE 9000
EXPOSE 9092

CMD docker.sh