FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install python3.8 && \
    apt-get -y install python3-pip && \
    apt-get -y install openssh-client

RUN pip3 install ansible

RUN echo "    IdentityFile /root/.ssh/aws_key" >> /etc/ssh/ssh_config
RUN echo "    PubkeyAuthentication yes" >> /etc/ssh/ssh_config
RUN echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config
