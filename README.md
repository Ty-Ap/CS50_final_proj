# CS50 Final Project
Intuitive and ergonomic network snooping.

### Checklist

 - [x] **IP Scraper**
        *Return IP address given domain*
	- [x] Use `dig` to get IP address
	- [ ] Run network IP sweep
 - [ ] **Port mapper**
		 *Return open ports of a given ip*
	- [x] Use `nc` to scan ports
	- [x] Remove clutter ( closed ports and useless information)
	- [ ] Display important information concisely and aesthetically
	- [ ] Suggest further actions based on results (redirect to *service fingerprinting* tool?)
	- [ ] Color code output
 - [ ] **Service fingerprinting**
		 *Fingerprint a given port at a given address*
		 
	- [ ] **Netcat Method**
        *Use netcat to detect services*
        - [ ] Run netcat command `nmap -sV <target_ip>` to detect services automatically
	 
	- [ ] **Manual method**
	 *Manually try certain methods of fingerprinting*
	
        - [ ] Get open ports (use `Port Mapper` tool)
        - [ ] Get banners with ncat `nc`
        - [ ] Parse banners for important data
	- [ ] Display important information concisely and aesthetically
	- [ ] Color code output

## Flow Chart
```mermaid
flowchart TD

    run[run.sh] --> |Set Variables| config(config/config.sh) -.-> init.sql & welcome
    run --> |Create Database| init.sql(init.sql)
    init.sql --> database[(Database)] 

    subgraph Assets
        shovel[/shovel.txt/]
        title[/title.txt/]
    end

    run --> welcome[welcome.sh]
        welcome --> select{Select tool}

        select --> IpScrapper
        select --> PortMapper
        select --> ServiceFingerprinter

        database --> IpScrapper.in
        database --> PortMapper.in1 & PortMapper.in2
        database --> ServiceFingerprinter.in1 & ServiceFingerprinter.in2



         subgraph IpScrapper
                    IpScrapper.in[/Domain/] --> IpScrapper.proccess(dig +short)
                    IpScrapper.proccess --> IpScrapper.out[/Ip Address/]
         end

         subgraph PortMapper
                    PortMapper.in1[/IP Address/] & PortMapper.in2[/Ports/] --> PortMapper.proccess(nc -zv -w 2)
                    PortMapper.proccess --> PortMapper.out[/Open Ports/]
         end

         subgraph ServiceFingerprinter
                    ServiceFingerprinter.in1[/IP Address/] & ServiceFingerprinter.in2[/Open Ports/] --> ServiceFingerprinter.proccess1(Get Banners)
                    ServiceFingerprinter.proccess1 --> ServiceFingerprinter.proccess2[Parse Banners]
                    ServiceFingerprinter.proccess2 --> ServiceFingerprinter.out[/Services/]
         end
            
            IpScrapper ~~~ PortMapper ~~~ ServiceFingerprinter
                    
            stdout(((output)))
            IpScrapper.out --> stdout
            PortMapper.out --> stdout
            ServiceFingerprinter.out --> stdout

            database2[(Database)]
            IpScrapper.out --> database2
            PortMapper.out --> database2
            ServiceFingerprinter.out --> database2

            stdout --> redo{Use another tool?}
            redo --> endchart(End) & restart(Goto select tool)
```
