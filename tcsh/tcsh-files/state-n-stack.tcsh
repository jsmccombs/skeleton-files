# 
# state-n-stack
#
# I like the fact that my history can be preserved on a per-machine basis, 
# even if I'm operating on a NFS mounted home directory.
#
# This lets state and dirstack be preserved based on username and machine.
#

set _tcshrc_state_dir=$HOME/.tcsh/state
mkdir -p $_tcshrc_state_dir

if(${?_tcshrc_state_dir} ) then
	if( -d $_tcshrc_state_dir && -w $_tcshrc_state_dir ) then
		# Load history.
		set histfile=$_tcshrc_state_dir/$HOST.$user.hist
		set savehist=($history merge)
		history -M
	
		#  directory stack.
		set dirsfile=$_tcshrc_state_dir/$HOST.$user.dirs
		set savedirs=500
		if ( ${#dirstack} <= 1 ) then
			set _curwd=$cwd
			dirs -L
			pushd $_curwd
			unset $_curwd
		endif
	else
		echo "crap"
	endif

	# We need to actually ALIAS "cd" now to use pushd, popd instead so we can have our dir history.
	set pushdtohome
	set pushdsilent
	alias cd 	'pushd'
	alias cdrem	'cd $dirrem'
	alias back	'pushd -'

endif
