FROM ubuntu:16.04

# Lo primero son los paquetes necesarios para acceder a HDFS
# JDK y Hadoop
RUN apt-get update && apt-get install -y openjdk-8-jdk wget
RUN wget http://apache.cs.utah.edu/hadoop/common/hadoop-3.2.0/hadoop-3.2.0.tar.gz
RUN tar zxf hadoop-3.2.0.tar.gz

# Descargamos algunas librerias necesarias para TF 
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        python \
        python-dev \
        rsync \
        software-properties-common \
        unzip \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip --no-cache-dir install \
        Pillow \
        h5py \
        ipykernel \
        jupyter \
        matplotlib \
        numpy \
        pandas \
        scipy \
        sklearn \
        && \
    python -m ipykernel.kernelspec

RUN pip --no-cache-dir install \
    http://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.8.0-cp27-none-linux_x86_64.whl