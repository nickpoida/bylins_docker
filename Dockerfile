#Bylins mud server
#source image is latest amazonlinux;
FROM amazonlinux:latest
#image maintainer is defined;
LABEL maintainer "Nikolay Poida - nickpoida@gmail.com"
#install dependencies;
RUN yum update -y && yum install boost gcc gcc-c++ expat wget zlib zlib-devel zlib-static libcurl-devel boost-devel boost-static gtest-devel gtest -y && yum clean all
#making environment and build
WORKDIR /opt
#installing latest version of git
RUN wget https://github.com/git/git/archive/v2.23.0.tar.gz && tar -xvf v2.23.0.tar.gz
WORKDIR /opt/git-2.23.0
RUN make prefix=/usr/local all && make install
#installing normal version of cmake
WORKDIR /opt
RUN wget https://github.com/Kitware/CMake/releases/download/v3.15.4/cmake-3.15.4.tar.gz && tar -zxvf cmake-3.15.4.tar.gz && ./cmake-3.15.4/bootstrap --prefix=/usr/local && gmake
WORKDIR /opt/cmake-3.15.4
RUN make && make install && rm -rf * ../
ENV PATH /usr/local/bin:$PATH:$HOME/bin
RUN mkdir /opt/mud
RUN git clone https://github.com/bylins/mud.git /opt/mud/ && mkdir /opt/mud/build
WORKDIR /opt/mud/build
RUN cmake -DSCRIPTING=NO -DCMAKE_BUILD_TYPE=Test -DBUILD_TESTS=NO && make && make install
#set capability to bind port
RUN setcap cap_net_bind_service=+ep /opt/mud/circle
#port 4000 exposed;
EXPOSE 4000
#RUN MUD
ENTRYPOINT ["/opt/mud/circle"]
