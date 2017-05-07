while read ID
	do
		WAIT=$(seq 0.1 0.05 0.5 | gshuf | head -1)
		PROXY=$(seq 1 10 | gshuf | head -1)
		UA=$(gshuf cidr.ua | head -1) 
		wget --user-agent="$UA" https://myip.ms/browse/ip_ranges/1/ownerID/"$ID"/ownerID_A/1 -q --proxy-user "2lk34jx0" --proxy-password "AXZmtolaxJcPnAZ5hkcLMfRzNTojs3YGehuOjsHjJz0=" use_proxy=yes -e http_proxy="de"$PROXY".nordvpn.com" -T 3 --tries=2
		grep CIDR: 1* | cut -d '>' -f7 | cut -d '<' -f1 | sed $'s/, /\\\n/g' >> cidr.output
		sleep "$WAIT"
		rm 1*
		cat cidr.output
		echo -e "# # # # # # # #"
		cat cidr.output | wc -l
		echo -e "# # # # # # # #"
	done <cidr.input
