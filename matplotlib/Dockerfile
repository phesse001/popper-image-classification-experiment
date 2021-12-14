FROM ubuntu:20.10
RUN apt-get update && apt-get install -y python3 python3-pip
RUN pip3 install matplotlib

ADD ../plot_results.py /workspace/plot_results.py
ADD ../results.txt /workspace/results.txt