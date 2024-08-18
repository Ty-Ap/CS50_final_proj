
Intuitive and ergonomic network snooping

# DigIt

### Checklist

 - [x] **IP Scraper**
        *Return IP address given domain*
	- [x] Use `dig` to get IP address
	- [x] Run network IP sweep
 - [x] **Port mapper**
		 *Return open ports of a given ip*
	- [x] Use `nc` to scan ports
	- [x] Remove clutter ( closed ports and useless information)
	- [x] Display important information concisely and aesthetically
	- [x] Suggest further actions based on results (redirect to *service fingerprinting* tool?)
	- [x] Color code output
 - [x] **Service fingerprinting**
		 *Fingerprint a given port at a given address*
	- [x] Get open ports (use `Port Mapper` tool)
        - [x] Get banners with ncat `nc`
        - [x] Parse banners for important data
	- [x] Display important information concisely and aesthetically
	- [x] Color code output
 - [x] **SQL Integration**
 	- [x] Save data from tools into database
  	- [x] Search function for saved data
 - [x] **Build fingerprinting**
	- [x] Get data from target
 	- [x] Interpret build based on data 

## Original Flow Chart
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

            subgraph extools[External Tools]
                msfconsole
                exploitdb
                whatweb
            end
            subgraph routing[Brute Force Routing]
                routing.in1[/Domain/]
                routing.in2[/wordlist.txt/]
                routing.proccess(Get request for every domain/word in wordlist)
                routing.in1 & routing.in2 --> routing.proccess
                routing.proccess --> routing.out[/"Results"/]
            end
            routing.out --> database2
            stdout --> extools & routing
```
## Current Flowchart
``` mermaid
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
        select --> Search.in2
        database --> Search.in1
        



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

         subgraph Search
            Search.in1[/Search Term/]
            Search.in2[/Saved Targets/]
            Search.in1 & Search.in2 --> Search.proccess(Regex Match)
            Search.proccess --> Search.out[/Matching targets/]
         end
            
            IpScrapper ~~~ PortMapper ~~~ ServiceFingerprinter
                    
            stdout(((output)))
            IpScrapper.out --> stdout
            PortMapper.out --> stdout
            Search.out --> stdout
            ServiceFingerprinter.out --> stdout

            database2[(Database)]
            IpScrapper.out --> database2
            PortMapper.out --> database2
            ServiceFingerprinter.out --> database2

            stdout --> redo{Use another tool?}
            redo --> endchart(End) & restart(Goto select tool)
```
## welcome.sh
``` mermaid
flowchart TD
    subgraph welcome.sh
    title(Print title & subtitle) --> getTools[/Get tools in /tools with extension .tool/]
    getTools --> select(Prompt a user selection for tool)
    select --> getUsage(Run tool with no arguments)
    getUsage --> parseArgs(Parse usage for arguments)
    parseArgs --> args[/Arguments/]
    args --> getInput(Get user input)
    getInput --> args
    getInput --> run(Run tool with input)
    run --> select
    end
```

## run.sh
``` mermaid
flowchart TD
    subgraph run.sh
    direction LR
    setup[Run setup scripts] --> config(config/config.sh) & queries(scripts/queries.py --setup)
    run[Start main program] --> start(scripts/welcome.sh)

    end
```
