#/bin/sh

script=`readlink -f "$0"`
cwd=`dirname "${script}"`
cd "${cwd}"
docker build -t sam80180/kubeadm:ubuntu18.04 .
