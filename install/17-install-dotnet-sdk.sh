# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch

export DOTNET_VERSION="7.0"

#.NET 6 is included in the Ubuntu 22.04 package manager feeds, but .NET 7 isn't.
# To install .NET 7 you must use the Microsoft package feed. 
# add the Microsoft package signing key to your list of trusted keys
# add the package repository
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Install the .NET SDK
apt-get update
apt-get install -y dotnet-sdk-${DOTNET_VERSION}

# Install .NET Interactive - used to install a Jupyter .NET kernel
dotnet tool install -g Microsoft.dotnet-interactive

# Install the .NET kernel by running the following:
# > dotnet interactive jupyter install
# You can verify the installation by running the following:
# > jupyter kernelspec list

# Fix permissions
fix-permissions.sh $HOME
# Cleanup
clean-layer.sh

# Layer size: 746 MB
# Total size: 2229 MB
