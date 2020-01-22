FROM registry.access.redhat.com/ubi8/ubi as builder

RUN yum -y install gcc make patch

WORKDIR /home
RUN curl https://mirrors.edge.kernel.org/pub/linux/utils/rt-tests/rt-tests-1.6.tar.gz >rt-tests-1.6.tar.gz
RUN tar xvzf rt-tests-1.6.tar.gz

WORKDIR /home/rt-tests-1.6
ADD no-privs.patch .
RUN patch -Np1 -i no-privs.patch
RUN make NUMA=0

FROM registry.access.redhat.com/ubi8/ubi-minimal

COPY --from=builder /home/rt-tests-1.6/cyclictest /usr/bin/
ENTRYPOINT ["/usr/bin/cyclictest"]
CMD ["--interval=200", "--distance=0"]

