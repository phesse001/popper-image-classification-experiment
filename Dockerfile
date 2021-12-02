FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y upgrade && \
    apt-get -y install python3.8 && \
    apt-get -y install git

RUN pip3.8 install numpy && \
    pip3.8 install torch torchvision

RUN mkdir -p /image-classification && \
    git clone https://github.com/phesse001/image-classification.git /image-classification

WORKDIR /image-classification