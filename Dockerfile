#
# Image configured with systemd, docker-in-docker and kubeadm.  Useful
# for simulating multinode Kubernetes deployments.
#
# The standard name for this image is maru/kubeadm
#
# Notes:
#
#  - disable SELinux on the docker host (not compatible with dind)
#
#  - to use the overlay graphdriver, ensure the overlay module is
#    installed on the docker host
#
#      $ modprobe overlay
#
#  - run with --privileged
#
#      $ docker run -d --privileged maru/kubeadm:ubuntu18.04
#

FROM sam80180/systemd-dind:ubuntu18.04

# https://tachingchen.com/tw/blog/kubernetes-installation-with-kubeadm/
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
	echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list

RUN apt-get update; apt-get install -y kubelet kubeadm kubectl kubernetes-cni
#RUN apt-get install -y bind-utils\
#	bridge-utils\
#	ebtables\
#	findutils\
#	hostname\
#	htop\
#	iproute\
#	iputils\
#	net-tools\
#	tcpdump\
#	traceroute

RUN systemctl enable kubelet

# kubeadm requires /etc/kubernetes to be empty
RUN rmdir /etc/kubernetes/manifests ; yes | kubeadm reset

# Docker requires /run have shared propagation in order to start the
# kube-proxy container.
RUN echo 'mount --make-shared /run' >> /usr/local/bin/dind-setup.sh

RUN swapoff -a
