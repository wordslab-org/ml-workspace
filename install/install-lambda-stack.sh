# https://github.com/lambdal/lambda-stack-dockerfiles/blob/master/Dockerfile.jammy

cd /root/

apt update && apt install -y git
git clone https://github.com/lambdal/lambda-stack-dockerfiles.git

# Add libcuda dummy dependency
DEBIAN_FRONTEND=noninteractive apt-get install --yes equivs
equivs-build ~/lambda-stack-dockerfiles/control
dpkg -i libcuda1-dummy_11.8_all.deb
rm control libcuda1-dummy_11.8*
apt-get remove --yes --purge --autoremove equivs
rm -rf /var/lib/apt/lists/*

# Setup Lambda repository
apt-get update
apt-get install --yes gnupg
gpg --dearmor -o /etc/apt/trusted.gpg.d/lambda.gpg < ~/lambda-stack-dockerfiles/lambda.gpg
rm lambda.gpg
echo "deb http://archive.lambdalabs.com/ubuntu jammy main" > /etc/apt/sources.list.d/lambda.list
echo "Package: *" > /etc/apt/preferences.d/lambda
echo "Pin: origin archive.lambdalabs.com" >> /etc/apt/preferences.d/lambda
echo "Pin-Priority: 1001" >> /etc/apt/preferences.d/lambda
echo "cudnn cudnn/license_preseed select ACCEPT" | debconf-set-selections

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends --option "Acquire::http::No-Cache=true" --option "Acquire::http::Pipeline-Depth=0" lambda-stack-cuda lambda-server
rm -rf /var/lib/apt/lists/*

# Setup for nvidia-docker
export NVIDIA_VISIBLE_DEVICES="all"
export NVIDIA_DRIVER_CAPABILITIES="compute,utility"
export NVIDIA_REQUIRE_CUDA="cuda>=11.8"
