#!/bin/sh 


 # bytes    packets errs drop fifo frame compressed multicast

if [ "$1" == "" ]; then 
	echo "Usage: $0 <eth-interface>" 
	exit 1;
fi 

function K() {
   echo "`echo "scale=4; $1 / 1024" | bc`"
}

function M() {
   echo "`echo "scale=4; $1 / 1048576" | bc`"
}
ReceiveLast=0
SendLast=0

second=`date +%s`
result=`cat /proc/net/dev | grep $1 | cut -d ':' -f 2`
i=0
for item in $result; do
	answer[$i]=$item;
        ((i++));
done
StartReceive=${answer[0]};
StartSend=${answer[8]};

sleep 1
while (true); do 
  result=`cat /proc/net/dev | grep $1 | cut -d ':' -f 2`
  i=0
  for item in $result; do 
	answer[$i]=$item;
	((i++));
  done
  ReceiveBytes=${answer[0]};
  ReceivePackets=${answer[1]};
  ReceiveErrors=${answer[2]};
  ReceiveDrop=${answer[3]};
  ReceiveFIFO=${answer[4]};
  ReceiveFrame=${answer[5]};
  ReceiveCompressed=${answer[6]};
  ReceiveMulticast=${answer[7]};

  SendBytes=${answer[8]};
  SendPackets=${answer[9]};
  SendErrors=${answer[10]};
  SendDrop=${answer[11]};
  SendFIFO=${answer[12]};
  SendFrame=${answer[13]};
  SendCompressed=${answer[14]};
  SendMulticast=${answer[15]};
  clear
  this_rec=`expr $ReceiveBytes - $ReceiveLast`
  total_rec=`expr $ReceiveBytes - $StartReceive`
  total_sec=`expr \`date +%s\` - $second`
  if (( this_rec >  1048576 )); then mega=true; else mega=""; fi;
  if (( this_rec > 1024 )); then kilo=true; else kilo=""; fi;

  if [ "$mega" ]; then 
  	echo "Receive `M $this_rec` M		Total: `M $total_rec` M		Rate: `M \`expr $total_rec / $total_sec\`` M/Sec"
  elif [ $kilo ]; then 
  	echo "Receive `K $this_rec` kBytes		Total: `K $total_rec` kBytes		Rate: `K \`expr $total_rec / $total_sec\`` kBytes/Sec"
  else 
  	echo "Receive " $this_rec "Bytes		Total:" $total_rec "Bytes		Rate:" `expr $total_rec / $total_sec` "Bytes/Sec"
  fi

  this_send=`expr $SendBytes - $SendLast`
  total_send=`expr $SendBytes - $StartSend`
  if [ $kilo ]; then 
  	echo "Receive `K $this_send` kBytes		Total: `K $total_send` kBytes		Rate: `K \`expr $total_send / $total_sec\`` kBytes/Sec"
  elif [ $mega ]; then 
  	echo "Receive `M $this_send` kBytes		Total: `M $total_send` kBytes		Rate: `M \`expr $total_send / $total_sec\`` kBytes/Sec"
  else 
  	echo "Sending " $this_send "Bytes		Total:" $total_send "Bytes			Rate:" `expr $total_send / $total_sec` "Bytes/Sec"
  fi
  sleep 1
  ReceiveLast=$ReceiveBytes
  SendLast=$SendBytes
 
done
