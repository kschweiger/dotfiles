#!/bin/bash
#.bash_functions
# T3PSI functions

rmSE() {
    echo $#
    if [ $# == 0 ]; then
	echo "Set at least one argument"
	echo "Usage rmSE /pnfs/path/to/folder [--debug]"
	return 0
    elif [ $# == 1 ]; then
	FOLDER=$1
    elif [ $# == 2 ]; then
	FOLDER=$1
	DEBUG=$2
    else
	echo "Maximum number of arguments is 2"
	return 0
    fi

    if [ "${DEBUG}" == "--debug" ]; then
	uberftp -debug 2 t3se01.psi.ch "rm -r ${FOLDER}"
    else
	uberftp t3se01.psi.ch "rm -r ${FOLDER}"
    fi
    
}


copySE() {
    if [ $# == 0 ]; then
	echo "Usage: copySE /pnfs/path/to/folder [path/to/dest]"
	echo "Destimation is optional. If not set will use current folder"
	return 0
    elif [ $# == 1 ]; then
	FOLDER=$1
	DEST="."
    elif [ $# == 2 ]; then
	FOLDER=$1
	DEST=$2
    else
	echo "Maximum of the arguments!"
	return 0
    fi
    
    uberftp t3se01.psi.ch "get -r  ${FOLDER} ${DEST}"
    return 1
}

uploadSE() {
     if [ $# != 2 ]; then
	echo "Usage: uploadSE localfile path/to/pnfs/dest"
	return 0
     else
	 LOCALFILE=$1
	 DEST=$2
     fi
     
     echo uberftp t3se01.psi.ch "put -r  ${LOCALFILE} ${DEST}"
     uberftp t3se01.psi.ch "put -r  ${LOCALFILE} ${DEST}"
     return 1
}


checkWorkQuota() {
	lynx  --dump --width=800 http://t3mon.psi.ch/PSIT3-custom/space.report  | egrep "NAME|$USER"
}

getKeysInFile() {
  python -c "import ROOT; f = ROOT.TFile.Open('${1}'); keys = sorted([x.GetName() for x in f.GetListOfKeys()]); print '\n'.join(keys);"
}

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
