## Custom Tools
This package allows you to create custom tools easily.

1. `cd tools` This directory is where all tools and scripts are stored.
2. `vim myTool.tool` or `nano myTool.tool` create a file with the extension `.tool` in your preferred editor
3. Add the line  `source $(dirname $0)/../scripts/initTool.sh "usage statement" $@` to your `myTool.tool` file. 
4. Customize the usage statement to match your tool. For example:
	`Usage $0 <domain_name> <port>` take the arguments **domain** and **port**
5. Add your code
6. Add execute permissions. `chmod 700 myTool.tool`
8. Your'e finished! Run `./run.sh` to and select your tool in the menu! 
9. (You can also run it standalone by just running the file Ex. `./myTool.tool`)

### Additional Features
If you would like to link to anther script, passing data from script to script, add the following line to your file

`link_tool <tool_name> <prompt> <args...>`

Fill the arguments respectively:
 - `tool_name`: the name of the tool you want to link to, excluding the `.tool` extension
 - `prompt`: the prompt you would like to display for the user, asking whether they want to continue with this link. (Future versions will allow the bypassing of this feature)
 - `args`: Any arguments/data you would like to pass on to the linked tool. Be sure to use the proper usage, just as if you were calling this tool from the command line.

### API
Other features, such as functions and variables are available in your tools.
Reference `api.md` for more information.
