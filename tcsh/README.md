TCSHRC

The files here are for use with the tcsh shell.

Yes, I know. Who uses tcsh still..

I do. :)

copy _tcshrc to $HOME/.tcshrc
copy the files in the tcsh directory to $HOME/.tcsh/


The tcshrc has the following features:

	1. Binds keys F1 through F12 to common system functions (uptime, list processes, etc.)
	2. Sets up paths 
	3. Sets up various TAB-completions
	4. customizes the prompt.
	5. Saves history and directory-stack information, preserving it between logins.


A NOTE ABOUT COMPLETION:
	
	The completion options in this are pretty advanced, especially around HOST NAME completion for things like "ssh", "scp", and the like.

	If you find yourself sshing to the same hosts often, edit $HOME/.tcsh/hosts.tcsh, and provide it a list of hosts you frequently visit. These will be added as options for completion to ssh, ping, wget, scp, and others.


