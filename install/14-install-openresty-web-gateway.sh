# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

# --- versions ---

# https://openresty.org/en/download.html
OPEN_RESTY_VERSION="1.21.4.1"

# --- end of versions ---

apt-get purge -y nginx nginx-common

# libssl-dev : Secure Sockets Layer toolkit - development files
apt-get install -y --no-install-recommends libssl-dev
# libpcre required, otherwise you get a 'the HTTP rewrite module requires the PCRE library' error
# libpcre3 : Old Perl 5 Compatible Regular Expression Library - runtime files
apt-get install -y --no-install-recommends libpcre3
# libpcre3-dev : Old Perl 5 Compatible Regular Expression Library - development files
apt-get install -y --no-install-recommends libpcre3-dev

# Install apache2-utils to generate user:password file for nginx.
# apache2-utils : Apache HTTP Server (utility programs for web servers)
apt-get install -y --no-install-recommends apache2-utils

mkdir $RESOURCES_PATH"/openresty"
cd $RESOURCES_PATH"/openresty" 
wget --no-verbose https://openresty.org/download/openresty-${OPEN_RESTY_VERSION}.tar.gz  -O ./openresty.tar.gz
tar xfz ./openresty.tar.gz 
rm ./openresty.tar.gz 

cd ./openresty-$OPEN_RESTY_VERSION/ 
# Suppress output - if there is a problem remove  > /dev/null
./configure --with-http_stub_status_module --with-http_sub_module > /dev/null
make -j2 > /dev/null 
make install > /dev/null 
# create log dir and file - otherwise openresty will throw an error
mkdir -p /var/log/nginx/ 
touch /var/log/nginx/upstream.log 

cd $RESOURCES_PATH 
rm -r $RESOURCES_PATH"/openresty" 
chmod -R a+rwx $RESOURCES_PATH 

mkdir -p /etc/nginx/nginx_plugins
cp -r ~/ml-workspace/resources/nginx/lua-extensions/. /etc/nginx/nginx_plugins

# Cleanup
clean-layer.sh

# Layer size: 22 MB 
# Total size: 872 MB
