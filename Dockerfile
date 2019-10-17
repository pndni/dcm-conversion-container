FROM centos:7.6.1810

RUN yum install -y epel-release && \
    yum install -y wget \
                   file \
                   bc \
                   tar \
                   gzip \
                   libquadmath \
                   which \
                   bzip2 \
                   libgomp \
                   tcsh \
                   perl \
                   less \
                   vim \
                   zlib \
                   zlib-devel \
                   hostname \
                   python36 \
                   python36-pip \
                   python36-devel \
                   libstdc++-static \
                   pigz \
                   python36-virtualenv \
                   git && \
    yum groupinstall -y "Development Tools" && \
    wget https://github.com/Kitware/CMake/releases/download/v3.14.0/cmake-3.14.0-Linux-x86_64.sh && \
    mkdir -p /opt/cmake && \
    /bin/bash cmake-3.14.0-Linux-x86_64.sh --prefix=/opt/cmake --skip-license && \
    rm cmake-3.14.0-Linux-x86_64.sh

RUN git clone --branch v1.0.20190902 https://github.com/rordenlab/dcm2niix.git && \
    pushd dcm2niix && \
    git checkout 0848baa590825c43e8fb03ccc7e68dcf0ade3d73 && \
    mkdir build && \
    pushd build && \
    /opt/cmake/bin/cmake -DCMAKE_INSTALL_PREFIX=/opt/dcm2niix .. && \
    make && \
    make install && \
    popd && popd && \
    rm -rf dcm2niix

RUN pip3.6 install heudiconv==0.5.4

ENV PATH=/opt/dcm2niix/bin:$PATH

ARG version="dev"
ARG revision=""
ARG builddate=""

LABEL org.opencontainers.image.title=dcm-conversion-container \
      org.opencontainers.image.vcs-url=https://github.com/pndni/dcm-conversion-container \
      org.opencontainers.image.version=$version \
      org.opencontainers.image.revision=$revision \
      org.opencontainers.image.build-date=$builddate \
      org.label-schema.build-date="" \
      org.label-schema.license="" \
      org.label-schema.name="" \
      org.label-schema.schema-version="" \
      org.label-schema.vendor=""
