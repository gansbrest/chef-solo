#!/bin/bash
 
# Usage: ./deploy.sh [host]

host=""
htname=""
set -- $(getopt fh: "$@")

while [ $# -gt 0 ]
do
  case "$1" in
    (-f) host="vagrant@192.168.33.3";;
    (-h) htname="$2"; shift;;
    (--) shift; break;;
    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
    (*)  break;;
  esac
shift
done

INSTALL_OPTS=""

if [[ ! $host ]]; then
  host="${1:-gansbrest@192.168.33.3}"
fi

host_ip=$(echo $host | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')

# Set hostname fore chef run
if [[ $htname && $host_ip ]]; then
  INSTALL_OPTS="-h $htname -i $host_ip"
fi

# The host key might change when we instantiate a new VM, so
# we remove (-R) the old host key from known_hosts
ssh-keygen -R "${host#*@}" 2> /dev/null
 
# Upload our ssh key so we can stop typing the remote password:
#if [ -e "$HOME/.ssh/id_rsa.pub" ]; then
  #cat "$HOME/.ssh/id_rsa.pub" | ssh -o 'StrictHostKeyChecking no' "$host" 'mkdir -m 700 -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'
#fi
 
#tar cjh . | ssh -o 'StrictHostKeyChecking no' "$host" '
#rm -rf /tmp/chef &&
#mkdir /tmp/chef &&
#cd /tmp/chef &&
#tar xj &&
#bash install.sh'

CHEF_SOLO_DIR="/opt/chef-solo"

# Use this version if you don't ssh in as root (e.g. on EC-2):
tar cj . | ssh -o 'StrictHostKeyChecking no' "$host" "

sudo sh -c 'rm -rf $CHEF_SOLO_DIR; mkdir $CHEF_SOLO_DIR; cd $CHEF_SOLO_DIR; tar xj; bash install.sh $INSTALL_OPTS $CHEF_SOLO_DIR; cp $CHEF_SOLO_DIR/chef_solo_boot.conf /etc/init'"
