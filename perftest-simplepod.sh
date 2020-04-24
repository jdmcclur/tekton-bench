oc patch deployment ubuntu-test -p '{"spec":{"replicas":1}}'
start=$(($(gdate +%s%N)/1000000))
while (true)
do
  if [[ $pod == "" ]]
  then 
    pod=$(oc get pods | grep ubuntu | awk '{print $1}')
  fi
  status=$(oc get pods | grep ubuntu | awk '{print $3}')
  echo $status
  oc get events | grep $pod

  if [[ $status == *Completed* ]]
  then
    break
  fi

done
stop=$(($(gdate +%s%N)/1000000))

total=$((($stop-$start)))


echo "Total=$total"
oc patch deployment ubuntu-test -p '{"spec":{"replicas":0}}'
