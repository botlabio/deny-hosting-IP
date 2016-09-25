# deny-hosting-IP
#### A system for anyone to easily identify over 130,000,000 cloud and hosting company IP addresses.

In 2014 Darkreading.com reported use of freely available cloud/hosting resources for malice in an article titled "CloudBot: A Free, Malwareless Alternative To Traditional Botnets"[[1]](http://www.darkreading.com/cloudbot-a-free-malwareless-alternative-to-traditional-botnets/d/d-id/1297878) based on research by BishopFox researchers[[2]](https://www.youtube.com/watch?v=cpUtYq4SJKA) Rob Ragan and Oscar Salazar. I highly recommend reading the article, and watching the video.  

Fast forward 2 years and "cloudbots" play a crucial role in fuelling sourced traffic market at the heart of the +$10 billion per year ad fraud wave. Depending on the publisher or ad platform, cloudbots usually represent upwards from 1% of total traffic. It is therefore alone a problem in the 9-figure (dollar) range. The good news is that allowing cloudbots to thrive in the online advertising eco-system is easy to stop, by systematically blocking traffic from hosting company IP ranges at both publisher and ad platform level. Here is an easy and low-cost way of starting to do it. 

### why is it important to filter out data center and hosting traffic from media inventory

While it can be fairly argued that filtering out data center traffic will result in many "false positives", this argument is not important in the media investment context. First because there is far more inventory (supply) than there is media budget (demand). Second 

Other reasons for seriously considering data center and cloud IP filtering: 

##### (1) Media Rating Council requires it from accredited traffic filtering companies

In its recent *Invalid Traffic Detection and Filtration Guidelines Addendum* the definite authority in standards work related to media quality, Media Rating Council says: 

The first, referred to as "General Invalid Traffic", consist of traffic identifed through routine means of filtration. Key examples are: known data-center traffic (determined to be a consistent source of non-human traffic; not including routing artifacts of legitimate users or virtual machines legitimate browsing"[3]. 

In addition to mentioning data center traffic, bots, spiders and crawlers are also mentioned as forms of 'general' invalid traffic. Requirement for accreditation for vendors is to cover extensively for 'general invalid traffic'. MRC's addendum is the basis for the Interactive Advertising Bureau's vendor accredication on advertising fraud. 


##### (2) Indepdent research found that fake traffic buying may have a strong association with "cloud IPs"

Similar to the US effort by MRC and IAB, UK based JICWEBS have released in 2015 its own Ad Fraud Traffic Taxonomy[4]. The document specifically mentions data-center traffic as "Illigimate and non-human traffic source". 


##### (3) Indepdent research found that fake traffic buying may have a strong association with "cloud IPs"

A recent research paper *Mystery Shopping Inside the Ad Verification Bubble* a researcher was able to demonstrate how he setup sites, connected the sites with monetization partners, bought sub penny per click traffic and drove it to the sites. The results show clearly how much of the traffic, that passed with flying colors through the filters of the best known ad fraud verification vendors Integral Ad Science and Moat, was coming from data center IPs.[5]


##### (4) Various forms of bots, scrapers and crawlers increasingly run on "cloud IPs" 

Most of the programmatic solutions to repeat various tasks run on server machines (and IP), and not home machines. As counter measures against web scraping and other tasks have become more sophisticated, headless browser based solutions to repeat tasks have quickly become the norm. Headless browsers trigger the ads on the sites they visit, in some cases very frequently. 

### what does this list cover? 

- most of the IP addresses owned by top100 hosting/cloud companies 
- most of the IP addresses in use by Google App Engine and content delivery 
- most of the IP addresses in use by AWS

### dependencies 

- mysql 
- prips (https://gitlab.com/prips/prips)

Other than these two dependencies, this git includes everything else you need. You could of course use any other db you like, and it's probably better to do it. For the sake of simplicity, here we provide a way even those without programming background can easily do it. 

### getting started 

1) Install mysql 

    sudo aptitude upgrade
    sudo apt-get update
    sudo apt-get install mysql-server 
    
2) Install prips 

    sudo apt-get prips

3) copy the cidr.txt file in to your /tmp folder (so mysql can access it later)

    curl https://raw.githubusercontent.com/botlabio/deny-hosting-IP/master/cidr.txt > /tmp/cidr.txt
    
4) run the command to expand the CIDR notation to invididual IP addresses: 
    
    cd /tmp
    while read CIDR; do prips "$CIDR" >> ip.txt; done <cidr.txt

5) login to mysql and excecute the following commands to create a database with one table: 

    CREATE DATABASE hosting_ip;
    USE hosting_ip;
    CREATE TABLE blacklist (ip VARCHAR(15) NOT NULL PRIMARY KEY);
    LOAD DATA INFILE '/tmp/ip.txt' INTO TABLE blacklist;

Depending on your system, this might take a little bit of time because there are a total of +130 million rows at the moment and this will grow as we keep updating the cidr.txt file. 

6) test that the creating of the database have been succesful: 

    SELECT * FROM blacklist WHERE ip='1.160.0.183';
   
If you get the result, then everything should be ok. 

You can run a single query directly from the command line using: 

    mysql -u USER -pPASSWORD -h localhost hosting_ip -e "SELECT * FROM blacklist WHERE ip='1.160.0.183'";
    
Or if you want to run multiple queries one after another going through a list of IPs: 

    while read IP; do mysql -u USER -pPASSWORD -h localhost hosting_ip -e "SELECT * FROM blacklist WHERE ip='$IP'" >> results.txt; done <list_of_ips.txt

### FAQ

**Why is this important?**

Cloudbots are unique in that they can be leveraged at scale by cybercriminals without spreading malware on to user devices first, simply by using cloud and hosting company server resources. While the cost of cloudbots to advertisers is significant, they are easy to stop by systematically blocking traffic from hosting company IP ranges at both publisher and ad platform level. 

**What can adtech companies do with this?**

Using this solution, adtech companies and publishers can easily minimize exposure to cloudbot traffic.   

**Is there any chance that using this list could block human traffic?**

While hosting company IP addresses are sometimes used as proxies, this use-case is neglible compared to cloudbot and other non-human traffic coming from hosting company IP addresses. 

**Will you be able to track how many people deploy it?**

While we are making this resource available in a way that does not allow us to track usage in anyway, we do engage in on-going "mystery shopping" tests where verification vendors' ability to detect cloudbot traffic is tested without their knowledge. Results are reported directly to the accreditation bodies such as MRC and TAG, and to advertiser associtions such as WFA, ANA and ISBA.

**How would an adtech company use this?**

There are three primary use-cases for this solution:

- for data analysis where it's valuable to know if a single IP is from cloud/hosting company
- same as above but do it for a lot of IP addresses (for example from a log-file) at one go
- for pre-bid filtering in a real-time stack (though you'll need a high performance db / system) 

**What is unique about this?**

The list of the IP addresses that cover top100 hosting / cloud companies. Because we give it in CIDR format, it’s just 50kb before you expand it in to a database (according to the instructions on the page). 

**Can this also be used for blocking as opposed to just detecting?**

You could use it just as blacklist by completing jus steps 1-4 above. Then you can use the resulting list as a blacklist. Also you could use the CIDR.txt file or the file resulting from completing steps 1-4 in various ways, for example on a server hosts file. You could also use the system as described above, but then use the detection result to add the IPs to a separate blacklist in your system. 

### references

[1] CloudBot: A Free, Malwareless Alternative To Traditional Botnets - http://www.darkreading.com/cloudbot-a-free-malwareless-alternative-to-traditional-botnets/d/d-id/1297878

[2] Black Hat USA 2014 - CloudBots - Harvesting Crypto Coins like a Botnet Farmer - https://www.youtube.com/watch?v=cpUtYq4SJKA

[3] http://mediaratingcouncil.org/GI063015_IVT%20Addendum%20Draft%205.0%20(Public%20Comment).pdf

[4] http://www.jicwebs.org/images/JICWEBS_Traffic_Taxonomy_October_2015.pdf

[5] http://www.slideshare.net/ShailinDhar/mystery-shopping-inside-the-adverification-bubble
