#!/bin/bash

if [[ -v GIT_SSH_HOST ]]; then

	tmp_file=$(mktemp)

	if [ -s '/etc/ssh/ssh_known_hosts' ]; then
	    cat '/etc/ssh/ssh_known_hosts' > ${tmp_file}
	fi

	host="${GIT_SSH_HOST}"
	ip=$(getent hosts "${host}" | awk '{ print $1 }')

	# Make sure any previous entry is gone
	ssh-keygen -R ${host} -f ${tmp_file}
	ssh-keygen -R ${ip} -f ${tmp_file}
	ssh-keygen -R ${host},${ip} -f ${tmp_file}

	ssh-keyscan -H ${host} >> ${tmp_file}
	ssh-keyscan -H ${ip} >> ${tmp_file}
	ssh-keyscan -H ${host},${ip} >> ${tmp_file}

	# SOMETHING keeps killing the permissions, keyscan?
	chmod 644 ${tmp_file}

	mv -f ${tmp_file} /etc/ssh/ssh_known_hosts

cat >/etc/ssh/ssh_config <<EOL
Host "${host}"
	HostName "${host}"
	Port 22
	User git
	IdentityFile ~/.ssh/user_syskey
	RequestTTY no

EOL

fi
