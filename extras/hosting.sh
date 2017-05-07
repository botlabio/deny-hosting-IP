while read IP
	do
	mysql -u root -pPASSWORD -h localhost hosting_ip -e "SELECT * FROM blacklist WHERE ip='$IP'";
done <hosting.input
