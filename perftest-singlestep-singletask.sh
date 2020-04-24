./run-singlestep-singletask
start=$(($(gdate +%s%N)/1000000))
while (true)
do
  if [[ $pod == "" ]]
  then 
    pod=$(oc get pods | grep task | awk '{print $1}')
  fi
  status=$(oc get pods | grep task | awk '{print $3}')
  echo $status
  oc get events | grep $pod
  if [[ $status == *Init:1/2* && $init1Done == "" ]]
  then
    #echo setInit1Done
    init1Done=$(($(gdate +%s%N)/1000000))
  fi
  
  if [[ $status == *PodInitializing* && $init2Done == "" ]]
  then
    #echo setInit2Done
    init2Done=$(($(gdate +%s%N)/1000000))
  fi

  if [[ $status == *Running* && $podInitDone == "" ]]
  then
    #echo podInit1Done
    podInitDone=$(($(gdate +%s%N)/1000000))
  fi

  if [[ $status == *Completed* ]]
  then
    #echo Done
    break
  fi

done
stop=$(($(gdate +%s%N)/1000000))

init1=$((($init1Done-$start)))
init2=$((($init2Done-$init1Done)))
podInit=$((($podInitDone-$init2Done)))
running=$((($stop-$podInitDone)))
total=$((($stop-$start)))


echo "Init1=$init1"
echo "Init2=$init2"
echo "PodInit=$podInit"
echo "Running=$running"
echo "Total=$total"
