FROM ubuntu:latest

ENV TZ=Europe/Zurich
ENV OMPI_ALLOW_RUN_AS_ROOT=1

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install -y iputils-ping mpich python3-mpi4py openssh-server

# Install shared ssh key
WORKDIR /root/.ssh/
COPY ./keys/ .

RUN chmod 600 ./id_rsa && \
    chmod 600 ./id_rsa.pub && \
    chmod 400 ./config && \
    eval $(ssh-agent -s) && \
    ssh-add ./id_rsa && \
    cat ./id_rsa.pub >> ./authorized_keys && \
    service ssh start

WORKDIR /cluster

EXPOSE 22

CMD ["tail", "-f", "/dev/null"]