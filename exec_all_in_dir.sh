#!/bin/bash
  
#Is the file an executable, return Boolean (0/1)
isExec() {
  
  #num of words from file
  numOfLines=`file $1 | awk -F: '{print $2}' | wc -w`
  
  #grabbing last word from string
  ifExec=`file $1 | awk -F: '{print $2}' | awk '{print $'$numOfLines'}'`
  
  #If last word of file $file is equal
  if [ "$ifExec" == "executable" ];then
    return 0 #true
  else
    return 1 #false
  fi
  
}
  
#Only one parameter allowed
if [ "$#" -ne "1" ];then
  echo "ERROR: usage $0 directory"
  exit 1
fi
  
#Parameter must be a directory
if [ `file $1 | awk '{print $2}'` != "directory" ]; then
  echo "Not a directory"
  exit 2
fi
  
#$1 is the directory
dir=$1
  
#go through entire Directory
ls -l $dir | awk '{print $9}' | tail -n +2 | while read file; do
  fullDir="$dir/$file"
  
  #File in Directory must be executable
  if isExec "$fullDir" $0;then
  
    #Execute file
    $1/$file
  else
    #File is not an executable
    echo "$file is not a executable file"
  fi
  
done
  
exit 0
