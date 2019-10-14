#Bylins mud server
#source image is latest amazonlinux;
FROM amazonlinux:latest
#image maintainer is defined;
LABEL maintainer "Nikolay Poida - nickpoida@gmail.com"
#install dependencies;
RUN yum update -y && yum install make boost gcc gcc-c++ expat expat-devel expat-static tar gzip wget gettext zlib zlib-devel zlib-static openssl-devel libcurl-devel boost-devel boost-static gettext-devel gtest-devel gtest -y && yum clean all
#making environment and build
ENV PATH /usr/local/bin:$PATH:$HOME/bin
WORKDIR /opt
#installing latest version of git
RUN wget https://github.com/git/git/archive/v2.23.0.tar.gz && tar -xvf v2.23.0.tar.gz
WORKDIR /opt/git-2.23.0
RUN make prefix=/usr/local all && make install
#installing normal version of cmake
WORKDIR /opt
RUN wget https://github.com/Kitware/CMake/releases/download/v3.15.4/cmake-3.15.4.tar.gz && tar -zxvf cmake-3.15.4.tar.gz && ./cmake-3.15.4/bootstrap --prefix=/usr/local && gmake && make && make install && mkdir /opt/mud && /root/bin/git clone https://github.com/bylins/mud.git /opt/mud/ && mkdir /opt/mud/build
#let's make it :)
WORKDIR /opt/mud/build
RUN cmake -DCMAKE_BUILD_TYPE=Release .. && nice -n 12 cmake --build . && nice -n 12 cmake --build . --target checks && mv circle .. && iconv -c -f utf8 -t koi8-r changelog > ../changelog
#set capability to bind port
RUN setcap cap_net_bind_service=+ep /opt/mud/circle
#port 4000 exposed;
EXPOSE 4000
#RUN MUD
WORKDIR /opt/mud/
CMD mv -R lib.template lib
ENTRYPOINT ["/opt/mud/circle"]
