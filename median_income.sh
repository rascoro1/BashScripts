#!/bin/bash
  
#this simple script will find the median household income and the average personal income of every county in the united states
  
stoperrorcount="0"
errorcount="0"
count="001"
stateid="01"
  
while true; do
  #Source of info
  link=`echo "http://quickfacts.census.gov/qfd/states/$stateid/$stateid$count.html"`
  
  #Test to see the link address
  #echo "TEST LINK: $link"
  
  #writing .html from URL to a file
  curl -s "$link" > htmlInfo
  
  #error=`cat htmlInfo | grep "404 Not Found"`
  
  #state var
  state=`cat htmlInfo | grep "County" | head -n 7 | awk -F\> '{print $20}' | awk '{print $1}' | tail -n 1`
  #County var
  county=`cat htmlInfo | grep "County" | head | grep Quick | awk -F\> '{print $2}' | awk -F\<  '{print $1}' | awk '{print $1}' | head -n 1`
  #Per capita var
  intCapita=`cat htmlInfo | grep "Per capita money income" | awk -F\< '{print $5}' | awk -F\> '{print $2}'`
  #Median household var
  intMedian=`cat htmlInfo | grep "Median household" | awk -F\< '{print $5}' | awk -F\> '{print $2}'`
  
  
  #less than 10
  if [[ $count == 00* ]];then
    count=`echo $count | sed "s/0//ig"`
    count=$(($count + 1))
  fi
  
  #less than 100 bun greater than 9
  if [[ $count == 0* ]];then
    #if number ends in 0
    if [[ $count == *0 ]];then
      count=`echo $count | sed "s/0//"`
      count=$(($count + 1))
    fi
  fi
  #if number just starts with 0
  if [[ $count == 0* ]];then
    count=`echo $count | sed "s/0//"`
    count=$(($count + 1))
  fi
  
  
  #greater than 99
  if [ "$count" -gt 99 ];then
    count=$(($count + 1))
  fi
  
  #if count is less than 100
  if [ "$count" -lt "100" ];then
  
    #if count is > 9 then add 0 in front of count
    if [ "$count" -gt "9" ];then
      count=`echo 0$count`
    fi
        
        #if count < 10 then add two 0 in front of count
    if [ "$count" -lt "10" ];then
      count=`echo 00$count`
    fi
        
  fi
  
  
  if [[ -z $county ]];then
    errorcount=$(($errorcount + 1))
    echo "ERROR COUNT: $errorcount"
    #Try new state
    if [ "$errorcount" -gt 20 ];then
      echo "ERROR, Will try New state"
      echo "ERROR MAX: $stoperrorcount"
      count="001"
      errorcount="0"
  
      #if stateid is greater than 9
      if [ "$stateid" -gt "9" ];then
          stateid=$(($stateid + 1))
      fi
      #if stateid is less than 10
      if [[ "$stateid" == 0*  ]];then
        if [ "$stateid" -eq "9" ];then
          stateid=`echo $stateid | sed "s/0//"`
          stateid=$(($stateid + 1))
        fi
        if [ "$stateid" -lt "9" ];then
          stateid=`echo $stateid | sed "s/0//"`
          stateid=$(($stateid + 1))
          stateid=`echo "0$stateid"`
        fi
      fi
  
      stoperrorcount=$(($stoperrorcount + 1))
  
      #no more states left
      if [ "$stoperrorcount" -gt "9" ];then
        echo "ERROR, No more states left!!"
        break
      fi
    fi
    continue 1
  fi
  
  #reset error count
  errorcount="0"
  #reset stop error count
  stoperrorcount="0"
  
  echo "County and State: $county, $state" >> searchinfo
  echo "Capita: $intCapita" >> searchinfo
  echo "Median: $intMedian" >>searchinfo
done
  
exit 0
