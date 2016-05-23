# deny-hosting-IP
#### A system for anyone to easily identify / block over 130,000,000 cloud and hosting company IP addresses.

In 2014 Darkreading.com reported use of freely available cloud/hosting resources for malice in an article title "CloudBot: A Free, Malwareless Alternative To Traditional Botnets"[1] covering research by BishopFox researchers[2] Rob Ragan and Oscar Salazar. I highly recommend reading the article, and watching the video.  

Fast forward 2 years and "cloudbots" play a crucial role in fuelling sourced traffic market at the heart of the +$10 billion per year ad fraud wave. Depending on the publisher or ad platform, cloudbots usually represent upwards from 1% of total traffic. It is therefore alone a problem in the 9-figure (dollar) range. The good news is that allowing cloudbots to thrive in the online advertising eco-system is easy to stop, by systematically blocking traffic from hosting company IP ranges at both publisher and ad platform level. Here is an easy and low-cost way of starting to do it. 

### what does this list cover? 

- most of the IP addresses owned by top100 hosting/cloud companies 
- most of the IP addresses in use by Google App Engine and content delivery 
- most of the IP addresses in use by AWS

### dependencies 

- mysql 
- prips (https://gitlab.com/prips/prips)

Other than these two dependencies, this git includes everything else you need. You could of course use any other db you like, and it's probably better to do it. For the sake of simplicity, here we provide a way even those without programming background can easily do it. 

### getting started 

1) copy the cidr.txt file in to your /tmp folder (so mysql can access it later)
2) run the command to expand the CIDR notation to invididual IP addresses: 
    
    while read CIDR; do prips "$CIDR" >> ip.txt; done <cidr.txt

3) login to mysql and excecute the following commands to create a database with one table: 

    CREATE DATABASE hosting_ip;
    USE hosting_ip;
    CREATE TABLE blacklist (ip VARCHAR(15) NOT NULL PRIMARY KEY);
    LOAD DATA INFILE '/tmp/ip.txt' INTO TABLE blacklist;

Depending on your system, this might take a little bit of time because there are a total of +130 million rows at the moment and this will grow as we keep updating the cidr.txt file. 

4) test that the creating of the database have been succesful: 

    SELECT * FROM blacklist WHERE ip='1.160.0.183';
   
If you get the result, then everything should be ok. 

You can run a single query directly from the command line using: 

    mysql -u USER -pPASSWORD -h localhost hosting_ip -e "SELECT * FROM blacklist WHERE ip='1.160.0.183'";
    
Or if you want to run multiple queries one after another going through a list of IPs: 

    while read IP; do mysql -u USER -pPASSWORD -h localhost hosting_ip -e "SELECT * FROM blacklist WHERE ip='$IP'" >> results.txt; done <list_of_ips.txt

### references

[1]http://www.darkreading.com/cloudbot-a-free-malwareless-alternative-to-traditional-botnets/d/d-id/1297878
[2]https://www.youtube.com/watch?v=cpUtYq4SJKA
