#
# $Id$
# example file using the new completion code
#
# Debian GNU/Linux
# /usr/share/doc/tcsh/examples/complete.gz
#
# This file may be read from user's ~/.cshrc or ~/.tcsh file by
# decompressing it into the home directory as ~/.complete and
# then adding the line "source ~/.complete" and maybe defining
# some of the shell variables described below.
#
# Added two Debian-specific completions: dpkg and dpkg-deb (who
# wrote them?). Changed completions of several commands. The ones
# are evaluated if the `traditional_complete' shell variable is
# defined.
#
# Debian enhancements by Vadim Vygonets <vadik@cs.huji.ac.il>.
# Bugfixes and apt completions by Miklos Quartus <miklos.quartus@nokia.com>.
# Cleanup by Martin A. Godisch <martin@godisch.de>.

onintr -
if (! $?prompt) goto end

if ($?tcsh) then
    if ($tcsh != 1) then
   	set rev=$tcsh:r
	set rel=$rev:e
	set pat=$tcsh:e
	set rev=$rev:r
    endif
    if ($rev > 5 && $rel > 1) then
	set _complete=1
    endif
    unset rev rel pat
endif

if ($?_complete) then
    set noglob
    if ( ! $?hosts ) set hosts
    foreach f ($HOME/.hosts $HOME/.tcsh/hosts /usr/local/etc/csh.hosts $HOME/.rhosts /etc/hosts.equiv /etc/hosts /usr/local/etc/csh.hosts $HOME/.rhosts /etc/hosts.equiv)
        if ( -r $f ) then
	    set hosts = ($hosts `grep -v "+" $f | grep -E -v "^#" | tr -s " " "	" | cut -f 1`)
	endif
    end
    if ( -r $HOME/.netrc ) then
	set f=`awk '/machine/ { print $2 }' < $HOME/.netrc` >& /dev/null
	set hosts=($hosts $f)
    endif
    if ( -r $HOME/.ssh/known_hosts ) then
	set f=`cat $HOME/.ssh/known_hosts | cut -f 1 -d \ ` >& /dev/null
	set hosts=($hosts $f)
    endif
    unset f
    if ( ! $?hosts ) then
	set hosts=(hyperion.ee.cornell.edu phaeton.ee.cornell.edu \
		   guillemin.ee.cornell.edu vangogh.cs.berkeley.edu \
		   ftp.uu.net prep.ai.mit.edu export.lcs.mit.edu \
		   labrea.stanford.edu sumex-aim.stanford.edu \
		   tut.cis.ohio-state.edu your-host-here)
    endif

    complete ssh	p/1/\$hosts/ c/-/"(l n)"/   n/-l/u/ N/-l/c/ n/-/c/ p/2/c/ p/*/f/
    complete telnet 	p/1/\$hosts/ p/2/x:'<port>'/ n/*/n/

    complete cd  	p/1/d/		# Directories only
    complete chdir 	p/1/d/
    complete pushd 	p/1/d/
    complete popd 	p/1/d/
    complete set	'c/*=/f/' 'p/1/s/=' 'n/=/f/'
    complete unset	n/*/s/
    complete alias 	p/1/a/		# only aliases are valid
    complete unalias	n/*/a/

    complete nslookup   p/1/x:'<host>'/ p/2/\$hosts/

    complete kill	'c/-/S/' 'c/%/j/' \
			'n/*/`ps -u $LOGNAME | awk '"'"'{print $1}'"'"'`/'

    complete perl	'n/-S/c/'
    complete printenv	'n/*/e/'
    complete setenv	'p/1/e/' 'c/*:/f/'

    complete acroread	'p/*/f:*.{pdf,PDF}/'
    complete apachectl  'c/*/(start stop restart fullstatus status graceful \
			configtest help)/'
    complete bison	'c/--/(debug defines file-prefix= fixed-output-files \
			help name-prefix= no-lines no-parser output= \
			token-table verbose version yacc)/' \
			'c/-/(b d h k l n o p t v y V)/' 'n/-b/f/' 'n/-o/f/' \
			'n/-p/f/'
    complete bunzip2	'p/*/f:*.bz2/' 
    complete bzip2	'n/-9/f:^*.bz2/' 'n/-d/f:*.bz2/'
    complete javac	'p/*/f:*.java/'
    complete netstat	'n@-I@`ifconfig -l`@'
    complete mysqladmin	'n/*/(create drop extended-status flush-hosts \
			flush-logs flush-status flush-tables flush-privileges \
			kill password ping processlist reload refresh \
			shutdown status variables version)/'
    

    complete ndc	'n/*/(status dumpdb reload stats trace notrace \
			querylog start stop restart )/'
    complete vim	'n/*/f:^*.[oa]/'
    complete where	'n/*/c/'
    complete which	'n/*/c/'
    complete wget 	c/--/"(accept= append-output= background cache= \
			continue convert-links cut-dirs= debug \
			delete-after directory-prefix= domains= \
			dont-remove-listing dot-style= exclude-directories= \
			exclude-domains= execute= follow-ftp \
			force-directories force-html glob= header= help \
			http-passwd= http-user= ignore-length \
			include-directories= input-file= level= mirror \
			no-clobber no-directories no-host-directories \
			no-host-lookup no-parent non-verbose \
			output-document= output-file= passive-ftp \
			proxy-passwd= proxy-user= proxy= quiet quota= \
			recursive reject= relative retr-symlinks save-headers \
			server-response span-hosts spider timeout= \
			timestamping tries= user-agent= verbose version wait=)"/


    complete ps	        c/-t/x:'<tty>'/ c/-/"(a c C e g k l S t u v w x)"/ \
			n/-k/x:'<kernel>'/ N/-k/x:'<core_file>'/ n/*/x:'<PID>'/
    complete compress	c/-/"(c f v b)"/ n/-b/x:'<max_bits>'/ n/*/f:^*.Z/
    complete uncompress	c/-/"(c f v)"/                        n/*/f:*.Z/

    complete uuencode	p/1/f/ p/2/x:'<decode_pathname>'/ n/*/n/
    complete uudecode	c/-/"(f)"/ n/-f/f:*.{uu,UU}/ p/1/f:*.{uu,UU}/ n/*/n/

    complete xhost	c/[+-]/\$hosts/ n/*/\$hosts/
    complete xpdf	c/-/"(z g remote raise quit cmap rgb papercolor       \
			      eucjp t1lib freetype ps paperw paperh level1    \
			      upw fullscreen cmd q v h help)"/                \
			n/-z/x:'<zoom (-5 .. +5) or "page" or "width">'/      \
			n/-g/x:'<geometry>'/ n/-remote/x:'<name>'/            \
			n/-rgb/x:'<number>'/ n/-papercolor/x:'<color>'/       \
			n/-{t1lib,freetype}/x:'<font_type>'/                  \
			n/-ps/x:'<PS_file>'/ n/-paperw/x:'<width>'/           \
			n/-paperh/x:'<height>'/ n/-upw/x:'<password>'/        \
			n/-/f:*.{pdf,PDF}/                                    \
			N/-{z,g,remote,rgb,papercolor,t1lib,freetype,ps,paperw,paperh,upw}/f:*.{pdf,PDF}/ \
			N/-/x:'<page>'/ p/1/f:*.{pdf,PDF}/ p/2/x:'<page>'/

    complete tcsh	c/-D*=/'x:<value>'/ c/-D/'x:<name>'/ \
			c/-/"(b c d D e f F i l m n q s t v V x X -version)"/ \
			n/-c/c/ n/{-l,--version}/n/ n/*/'f:*.{,t}csh'/

    complete rpm	c/--/"(query verify nodeps nofiles nomd5 noscripts    \
	                nogpg nopgp install upgrade freshen erase allmatches  \
		        notriggers repackage test rebuild recompile initdb    \
		        rebuilddb addsign resign querytags showrc setperms    \
		        setugids all file group package querybynumber qf      \
		        triggeredby whatprovides whatrequires changelog       \
		        configfiles docfiles dump filesbypkg info last list   \
		        provides queryformat requires scripts state triggers  \
		        triggerscripts allfiles badreloc excludepath checksig \
	                excludedocs force hash ignoresize ignorearch ignoreos \
		        includedocs justdb noorder oldpackage percent prefix  \
		        relocate replace-files replacepkgs buildroot clean    \
		        nobuild rmsource rmspec short-circuit sign target     \
		        help version quiet rcfile pipe dbpath root specfile)"/\
		        c/-/"(q V K i U F e ba bb bp bc bi bl bs ta tb tp tc  \
			ti tl ts a f g p c d l R s h ? v vv -)"/              \
		n/{-f,--file}/f/ n/{-g,--group}/g/ n/--pipe/c/ n/--dbpath/d/  \
		n/--querybynumber/x:'<number>'/ n/--triggeredby/x:'<package>'/\
		n/--what{provides,requires}/x:'<capability>'/ n/--root/d/     \
		n/--{qf,queryformat}/x:'<format>'/ n/--buildroot/d/           \
		n/--excludepath/x:'<oldpath>'/  n/--prefix/x:'<newpath>'/     \
		n/--relocate/x:'<oldpath=newpath>'/ n/--target/x:'<platform>'/\
		n/--rcfile/x:'<filelist>'/ n/--specfile/x:'<specfile>'/       \
	        n/{-[iUFep],--{install,upgrade,freshen,erase,package}}/f:*.rpm/

endif
unset noglob

end:
	onintr
