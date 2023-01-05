# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

# openssh-client : secure shell (SSH) client, for secure access to remote machines
apt-get install -y --no-install-recommends openssh-client

# openssh-server : secure shell (SSH) server, for secure access from remote machines
apt-get install -y --no-install-recommends openssh-server

# sslh : Applicative protocol multiplexer
apt-get install -y --no-install-recommends sslh

# autossh : Automatically restart SSH sessions and tunnels
apt-get install -y --no-install-recommends autossh

# mussh : MUltihost SSH Wrapper
apt-get install -y --no-install-recommends mussh

# prepare ssh for inter-container communication for remote python kernel
chmod go-w $HOME 
mkdir -p $HOME/.ssh/
touch $HOME/.ssh/config  
sudo chown -R $NB_USER:users $HOME/.ssh 
chmod 700 $HOME/.ssh 
printenv >> $HOME/.ssh/environment 
chmod -R a+rwx /usr/local/bin/ 

# Fix permissions
fix-permissions.sh $HOME
# Cleanup
clean-layer.sh

# Layer size: 5 MB 
# Total size: 796 MB