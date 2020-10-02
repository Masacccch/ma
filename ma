#!/bin/sh


function call(){
  if [ $# != 1 ] ; then
    echo "need: ma [NUM] or ma -r [CMD] [NUM] or -l,"
  else
    echo -n "called -$1-["
    while read line 
    do
      if [ ${line:0:1} = "${1}" ] ; then
        echo "${line:2}]"
        eval ${line:2}
      fi
    done < $SDIR/data.ini
  fi
}

function regist(){
  if [ $# != 2 ] ; then
    echo "need: ma [CMD] [NUM]"
  else
    echo "regi +$1+ [$2]"
    echo "$2 $1" >>$SDIR/data.ini
  fi
}

function list(){
  echo "-----"
  while read line 
  do
    echo $line
  done < $SDIR/data.ini
  echo "+---+"
}

delete(){
  sed "$1d" $SDIR/data.ini -i
  list
}

##### MAIN ###### 

#echo "Hello ma CLI in sh"
SDIR=$(cd $(dirname $0); pwd)

while getopts r:ld: OPT; do
  case $OPT in
	  l) FLAG_L="TRUE" ;;
	  r) FLAG_R="TRUE"; VALUE_R="$OPTARG" ;;
	  d) FLAG_D="TRUE"; VALUE_D="$OPTARG" ;;
  esac
done

if [ "${FLAG_R}" ] ; then
  #echo "resigter"
  regist "$VALUE_R" $3;
elif [ "${FLAG_L}" ] ; then 
  list
  #echo "lister"
elif [ "${FLAG_D}" ] ; then 
  delete "$VALUE_D"
  #echo "deleter"
else
  call $1
  #echo "caller"
fi


