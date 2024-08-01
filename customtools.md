## Custom Tools
This package allows you to create custom tools easily.

1. `cd scripts` This directory is where all tools and scripts are stored.
2. `vim myTool.sh` or `nano myTool.sh` create a bash script with your preferred editor
3. Add the line  `source $(dirname $0)/initTool.sh "usage statement" $@` to your `myTool.sh` file. 
4. Customize the usage statement to match your tool. For example:
	`Usage $0 <domain_name> <port>` take the arguments **domain** and **port**
5. Add your code
6. Add execute permissions. `chmod 700 myTool.sh`
7.  Add your script name to `welcome.sh`. There is a large select and case statement with several tools already added. Add yours similarly.
> [!IMPORTANT]
> This proccess will be a lot easier in future updates 
8. Your finished! Run `./run.sh` to and select your tool in the menu! 
9. ( You can also run it standalone by just running the file Ex. `./myTool.sh`) 
