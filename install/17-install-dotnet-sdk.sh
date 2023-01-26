# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch

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

# Cleanup
clean-layer.sh

# Layer size: 746 MB
# Total size: 2229 MB
