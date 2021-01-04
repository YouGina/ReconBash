# ReconBash
Bash recon scripts for my personal use and possible helpful others. It's nothing special, just launches specific programs in a specific other.

Some of these scripts might contain snippets shared by others. I would like to thank everyone who might have contributed this way.

These scripts assume a TARGET_PATH environment variable exists pointing to a directory where all your target programs are. Every target should have it's own folder of which the name is the name of the target as listed in hackerone (this is not a requirement, unless you want to make use of the receive_scope python script and check scope scripts).

Furthermore there should be a RECON_BASH_BASEPATH environment variable which contains the path of all the .sh files. This path is used by the execute_all script.

There are some dependencies for external programs wich you can roughly find by looking at the names of the scripts.

To use the receive_scope.py you need the token which you can find in the requests hackerone.com makes after logging in. This script uses your bookmarked and active programs from hackerone. You can exclude specific programs by adding them to the program_blacklist in the top of the receive_scope.py