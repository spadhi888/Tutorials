#!/bin/sh

source ./condor.sh

start(){

cat > tmp.sh << EOF
 #!/bin/bash
 source ./condor.sh
 while true
  do
   NumAnnex=\`condor_q -const 'JobStatus == 1' | grep -i 'Total for all users' | awk '{print \$11}'\`
   if [ "\$NumAnnex" -gt "0" ]; then
     echo yes | condor_annex -count \$NumAnnex -annex-name MyFirstAnnex -no-owner
   fi
   sleep 500
  done

EOF

   chmod a+x tmp.sh
   nohup ./tmp.sh > auto.log 2>&1 &
   echo $! > save_pid.txt
#   cat tmp.sh
   return 0
}

stop(){
   kill -9 `cat save_pid.txt`
   rm -rf save_pid.txt tmp.sh
   return 0
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  *)
    echo $"Usage: $0 {start|stop}"
    exit 1
esac

exit $?

