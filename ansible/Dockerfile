FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install python3.8 && \
    apt-get -y install python3-pip && \
    apt-get -y install openssh-server

RUN pip3 install ansible

ADD hosts /root/home/ansible/hosts
ADD experiment.yml /root/home/ansible/experiment.yml
ADD packages.yml /root/home/ansible/packages.yml
ADD ansible.cfg /root/home/ansible/ansible.cfg

RUN echo "    IdentityFile ../.ssh/aws_key" >> /etc/ssh/ssh_config
RUN echo "    PubkeyAuthentication yes" >> /etc/ssh/ssh_config
RUN echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config

WORKDIR /root/home/ansible