FROM ubuntu:16.04
MAINTAINER Soo Lee (duplexa@gmail.com) Clara Bakker (Clara_Bakker@hms.harvard.edu)

# 1. General updates and necessary Linux components
RUN apt-get update -y && apt-get install -y \
   bzip2 \
   default-jre \
   gcc \
   git \
   less \
   libncurses-dev \
   make \
   man \
   r-base-dev \
   time \
   unzip \
   vim \
   wget \
   zlib1g-dev \
   liblz4-tool \
   libbz2-dev \
   liblzma-dev \
   libxml2-dev \
   libxslt-dev

RUN apt-get update -y && apt-get install -y \
    python3.5-dev \
    python3-setuptools \
    && wget https://bootstrap.pypa.io/pip/3.5/get-pip.py \
    && python3.5 get-pip.py

WORKDIR /usr/local/bin
ENV PATH=/usr/local/bin/:$PATH

RUN pip3 install numpy==1.18.5
RUN pip3 install scipy==1.4
COPY downloads.sh . 
RUN chmod +x downloads.sh && \
    . downloads.sh && \
    rm /usr/local/bin/downloads.sh

COPY scripts/ .
RUN chmod +x run*.sh *gauss*

# CMD ["run-cut-and-run.sh"]
