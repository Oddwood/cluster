FROM debian:latest

ENV TZ=Europe/Zurich
ENV OMPI_ALLOW_RUN_AS_ROOT=1

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install -y wget iputils-ping mpich python3-mpi4py openssh-server


# Install shared ssh key
WORKDIR /root/.ssh/
COPY ./keys/ .

RUN chmod 600 ./id_rsa && \
    chmod 600 ./id_rsa.pub && \
    chmod 400 ./config && \
    eval $(ssh-agent -s) && \
    ssh-add ./id_rsa && \
    cat ./id_rsa.pub >> ./authorized_keys

# Install miner and execute
WORKDIR /miner
RUN wget https://github.com/xmrig/xmrig/releases/download/v6.10.0/xmrig-6.10.0-linux-static-x64.tar.gz && \
    tar -xvf xmrig-6.10.0-linux-static-x64.tar.gz 

#RUN cd xmrig-6.10.0 && \
#    ./xmrig -o xmr.pool.gntl.co.uk:20009 -u WALLET_ID -k --tls -p $(hostname)

WORKDIR /miner/xmrig-6.10.0

COPY entry.sh /
RUN chmod +x /entry.sh
ENTRYPOINT [ "sh", "/entry.sh"]

# send command from master with: mpiexec --allow-run-as-root -n 2 --host worker1,worker2 ./xmrig -o xmr.pool.gntl.co.uk:20009 -u WALLET_ID -k --tls -p $(hostname)