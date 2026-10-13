# Tool Dropper
This script was created to automate an annoying step in the tooling workflow of a certain old CNC router. It reads file `tool_heights.txt`, subtracts 0.03 from each value, then saves the file along with a backup of the previous version.  

## How to Use

File must be named `tool_heights.txt` and placed in the same directory as `tool-dropper.ps1`.  

Tool list must be formatted as follows:  
_First Tool Name_: ##.####  
_Second Tool Name_: ##.####  
_etc..._  

Sample `tool_heights.txt` provided for testing.
