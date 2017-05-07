while read IP
	do
	mysql -u root -ppu8x3+zmHAU+nNw9f0FeKM1dgfg= -h localhost hosting_ip -e "SELECT * FROM blacklist WHERE ip='$IP'";
done <hosting.input