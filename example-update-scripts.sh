#!/bin/sh
#when some variables are null ,abord the shell running.
set -x -u -e
log_dir="/usr/lib/mylibs/acme_tiny/logs"
log_file="${log_dir}/update.log"
acme_tiny_py="/usr/lib/mylibs/acme_tiny/acme_tiny.py"
account_key="/usr/lib/mylibs/acme_tiny/acme_account.key"
csr_file="/app/chfs/uhttpd.csr"
acme_dir="/usr/lib/mylibs/acme_tiny/.well-known/acme-challenge/"
save_to_dir="/tmp/acme"
save_to="${save_to_dir}/uhttpd-new.crt"
#prepare
mkdir -p ${save_to_dir}
mkdir -p ${acme_dir}
mkdir -p ${log_dir}

#start nginx server
2>&1 /etc/init.d/nginx start |tee -a ${log_file}
2>&1 /etc/init.d/nginx start |tee -a ${log_file}
#recode date
echo \#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#Current Date: $(date "+%Y-%m-%d %H:%M:%S")\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#  |tee -a ${log_file}

#excute update py scripts
2>&1 python /usr/lib/mylibs/acme_tiny/acme_tiny.py --account-key /usr/lib/mylibs/acme_tiny/acme_account.key --csr /app/chfs/uhttpd.csr --acme-dir /usr/lib/mylibs/acme_tiny/.well-known/acme-challenge/ --save-to ${save_to} |tee -a ${log_file}

#verify the crt
priout=$(openssl rsa -pubout -in /app/chfs/uhttpd.key)
pubout=$(openssl x509 -pubkey -noout -in ${save_to})

#correct key (public key matched)
if [ "$pubout" = "$priout" ];then
	if [ ! -f "/app/chfs/uhttpd.crt" ];then
		mv /app/chfs/uhttpd.crt /app/chfs/uhttpd.crt.bak
	fi
	mv ${save_to} /app/chfs/uhttpd.crt
#has content but verify failed
elif [ -n "$pubout" ];then
	mv ${save_to} /app/chfs/uhttpd-new-verify-failed.crt
fi

#stop nginx server
2>&1 /etc/init.d/nginx stop |tee -a ${log_file}
2>&1 /etc/init.d/nginx stop |tee -a ${log_file}

#clean log file (prevent only 2000 lines left!!!)
A=$(sed -n '$=' ${log_file})
2>/dev/null sed -i 1,$(($A-2000))d ${log_file}


