FROM ubuntu:14.04
MAINTAINER Juan Ferreira "juan.ferreira@me.com"

ARG OPENCV_VERSION="3.1.0"

# Install dependencies
RUN apt-get update && \
	apt-get install -y software-properties-common python-software-properties && \
	add-apt-repository -y ppa:george-edison55/cmake-3.x && \
	apt-get update && \
	apt-get install -y build-essential git cmake && apt-get upgrade -y cmake

WORKDIR /tmp

# Install openCV
RUN git clone https://github.com/Itseez/opencv.git && \
	cd opencv && \
	git checkout tags/$OPENCV_VERSION && \
	cmake -DWITH_IPP=OFF && \
	make && \
	make install

# Configure
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf
RUN ldconfig

# Clean up apt-get cache (helps keep the image size down)
RUN apt-get remove --purge -y git
RUN apt-get autoclean && apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/*