FROM ubuntu:14.04.2
ENV DEBIAN_FRONTEND noninteractive
MAINTAINER Scalyr Inc <support@scalyr.com>
RUN apt-get update && apt-get install -y \
  apt-transport-https \ 
  build-essential \
  gcc \
  git \  
  python \
  ruby-dev \
  wget && \
  apt-get clean
RUN gem install fpm
RUN cd /usr/bin && mkdir -p /tmp/scalyr && \
  git config --global user.name "Scalyr" && git config --global user.email support@scalyr.com && \
  git clone git://github.com/ReturnPath/scalyr-agent-2.git /tmp/scalyr && \
  cd /tmp/scalyr && \ 
  git checkout master && \
  python build_package.py deb && \
  dpkg -i scalyr-agent-2_2.0.16_all.deb && \
  cd / && \
  rm -rf /tmp/scalyr
CMD ["/usr/sbin/scalyr-agent-2", "--no-fork", "--no-change-user", "start"]
