#!/bin/bash
host_name=""
host_ip=""
set -- $(getopt i:h: "$@")

while [ $# -gt 0 ]
do
  case "$1" in
    (-i) host_ip="$2"; shift;;
    (-h) host_name="$2"; shift;;
    (--) shift; break;;
    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
    (*)  break;;
  esac
shift
done

if [[ $host_name && $host_ip ]]; then
  host_short=$(echo $host_name | cut -d'.' -f 1)
  echo "$host_short" | sudo tee /etc/hostname
  hostname -F /etc/hostname
  echo "$host_ip $host_name $host_short" | sudo tee -a /etc/hosts
fi

# This runs as root on the server
chef_binary=/usr/bin/chef-solo

# Are we on a vanilla system?
if ! test -f "$chef_binary"; then
    export DEBIAN_FRONTEND=noninteractive
    # Upgrade headlessly (this is only safe-ish on vanilla systems)
    #apt-get update -o Acquire::http::No-Cache=True
    #apt-get -o Dpkg::Options::="--force-confnew" \
      #--force-yes -fuy dist-upgrade

    # Install RVM as root (System-wide install)
    apt-get install -y curl git-core bzip2 build-essential zlib1g-dev libssl-dev libreadline-dev

    #bash <(curl -L https://github.com/wayneeseguin/rvm/raw/1.3.0/contrib/install-system-wide) --version '1.3.0'
    #(cat <<'EOP'
#[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"
#EOP
    #) > /etc/profile.d/rvm.sh

    # Install Ruby using RVM
    #[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"
    #rvm install 1.9.3-p0
    #rvm use 1.9.3-p0 --default
    #if [ ! -e '/usr/local/rvm/bin' ]; then
      #ln -s /usr/local/bin /usr/local/rvm/bin;
    #fi

    # Install ruby
    aptitude install -y ruby1.9.3
    aptitude install -y rubygems

    # Install chef
    gem install --no-rdoc --no-ri chef-rewind

    curl -L https://www.opscode.com/chef/install.sh | sudo bash
fi
 
# Run chef-solo on server
"$chef_binary" -c $1/.chef/solo.rb -j $1/solo.json
