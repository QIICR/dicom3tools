FROM fedorov/docker-centos-build
MAINTAINER http://github.com/QIICR

WORKDIR /usr/src
RUN git clone http://github.com/QIICR/dicom3tools.git && \
  cd dicom3tools && \
  git checkout docker && \
  ./Configure && \
  imake -I./config -DInstallInTopDir && \
  make World && \
  make install 

RUN  chmod a+x /usr/src/dicom3tools/docker_entry.sh

ENTRYPOINT ["/bin/bash","/usr/src/dicom3tools/docker_entry.sh"]
