#!/bin/bash

echo -e "\n \n"
echo  "###################################################"
echo  "####              IMAGE BUILD TOOL             ####"
echo  "###################################################"
echo -e "\n \n"

oldbuilds="Archive"
builddir="builds"
maxbuildcount=3
minbuildcount=0

for i in $oldbuilds $builddir; do
  if [ ! -d "$i" ]; then
    mkdir $i && echo "INFO: Creating directory $i ..."
  else
    echo "INFO: Directory $i already exists !"
  fi
done
archivecount=$(ls $oldbuilds | wc -l)

if [ -z "$(ls -A builds/)" ]; then
   echo "INFO: No previous build data found. Maybe it's the first run ..."
else
   if [ "$archivecount" -lt "$maxbuildcount" ]; then
     mkdir -p $oldbuilds/build-$(date +%F_%R)
     mv $builddir/* $oldbuilds/build-$(date +%F_%R)/ && echo "INFO: Moving previous build data to Archive ..." || \
     { echo "ERROR: Unable to move previous build data to Archive. Exiting ... "; exit 1; }
   elif [ "$archivecount" -eq "$maxbuildcount" ]; then
     cd $oldbuilds && rm -rf $(ls -t1 | tail -n 1) && echo "WARNING: Archive threshold reached, removing the last created build" || \
     { echo "ERROR: Unable to delete last created build. Exiting ... "; exit 1; }
     cd - > /dev/null
   else
     echo "ERROR: Something went wrong with archive operations of build. Exiting ..."; exit 1;
   fi
fi


begin=$(date +"%s")
echo -e "INFO: Checking for necessary files ... \n"
for file in scripts/utility_install.sh vboxcentos7.json; do
  if [ -f "$file" ]; then
    echo "INFO: $file found"
  else
    echo "INFO: $file not found. Exiting ..."; exit 1;
  fi
done

echo -e "INFO: All good. Commencing build of CentOS server using Packer ;-) \n "
begin=$(date +"%s")
packer build -force vboxcentos7.json | tee build.log
grep -w "VBoxManage: error" build.log > /dev/null
status=$?
if [ "$status" -eq 0 ]; then
  echo -e " \nERROR: *** BUILD FAILURE: Issues encountered with VBoxManage ***"
  VBoxManage unregistervm CentOS-server
  rm -rf /home/$USER/VirtualBox\ VMs/CentOS-server/ && rm -f *.vdi && \
  echo -e "INFO: Retrieving previous machine state \n \n" || { echo -e "ERROR: Unable to revert system to previous state. Next run might fail ... \n"; exit 1; }
  for i in {1..5}; do
    echo "Attempt #" $i
    echo "Waiting for 5 seconds before re-running Packer build ..."
    sleep 5
    packer build -force vboxcentos7.json
    if [ "$status" -eq 0 ]; then
      break
    fi
  done
fi
termin=$(date +"%s")
difftimelps=$(($termin-$begin))
mv builds/CentOS-server.ova builds/CentOS-server-$(date +%F_%R).ova && echo "INFO: Appending timestamp to the image"
echo -e "This CentOS build took $(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds !! \n"
