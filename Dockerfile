#Bylins mud server
#source image is latest amazonlinux;
FROM amazonlinux:latest
#image maintainer is defined;
LABEL maintainer "Nikolay Poida - nickpoida@gmail.com"
#install dependencies;
RUN yum update -y && yum install git boost gcc gcc-c++ wget zlib zlib-devel zlib-static boost-devel boost-static gtest-devel gtest -y && yum clean all
#making environment and build
WORKDIR /opt
RUN wget https://cmake.org/files/v3.6/cmake-3.6.2.tar.gz && tar -zxvf cmake-3.6.2.tar.gz && ./cmake-3.6.2/bootstrap --prefix=/usr/local && gmake
WORKDIR /opt/cmake-3.6.2
RUN make && make install && rm -rf *
ENV PATH /usr/local/bin:$PATH:$HOME/bin
RUN mkdir /opt/mud
RUN git clone https://github.com/bylins/mud.git /opt/mud/
WORKDIR /opt/mud
RUN cmake -DSCRIPTING=NO -DCMAKE_BUILD_TYPE=Test -DBUILD_TESTS=NO && make && make install
RUN setcap cap_net_bind_service=+ep /opt/mud/circle
#port 4000 exposed;
EXPOSE 4000
#RUN Mud
ENTRYPOINT ["/opt/mud/circle", "-D", "FOREGROUND"]
