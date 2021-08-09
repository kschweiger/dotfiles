#!/bin/bash
#.bash_functions

# General functions
tattach() {
    if [ $# == 0 ]; then
       echo "Pass session name"
       return 1
    fi
    tmux attach -t $1
}

viewCSV() {
    if [ $# == 1 ]
    then
        sed 's/;;/; ;/g; s/;;/; ;/g' $1 | column -s\; -t | less -#2 -N -S
    else
        echo "Please specify file"
    fi
}

viewCSVcomma() {
    if [ $# == 1 ]
    then
        cat $1 | column -s, -t | less -#2 -N -S
    else
        echo "Please specify file"
    fi
}

findDirecory() {
    if [ $# == 1 ]
    then
	find . -type d | grep $1
    else
	echo "Please pass exactly one dir name"
    fi
}

untarAll() {
    for file in ls -f *; do tar xvf $file; done
}

sshAgent() {
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
}

sshClean() {
   if [ $#  == 1 ];then
	ssh -t $1 bash --noprofile
   else
	echo "Exactly one arg required"
   fi
}
