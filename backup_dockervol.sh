#!/bin/bash
#
#
BCKDIR=/home/volbackup
date=$(date +%Hh%Mm_%d%m%Y)

if [ ! -d ${BCKDIR} ]
then
  echo "${BCKDIR} is unreachable, please investigate and launch again this script"
  exit 1
fi

function interactiveBackup()
{
  echo "ENSURE THAT CONTAINER IS STOPPED !, press enter to continue."
  echo
  read
  echo "Enter volume to backup"
  docker volume ls
  read volname
  docker run -v ${volname}:/volume --rm loomchild/volume-backup backup - > ${BCKDIR}/${volname}_${date}.tar.bz2
  echo "$(date) ## Volume: ${volname} was saved to ${BCKDIR}/${volname}_${date}.tar.bz2 ##"
  echo
  echo "You can now restart container(s)."
}

function backup()
{
  docker run -v ${volname}:/volume --rm loomchild/volume-backup backup - > ${BCKDIR}/${volname}_${date}.tar.bz2
  echo "$(date) ## Volume: ${volname} was saved to ${BCKDIR}/${volname}_${date}.tar.bz2 ##"
}

function interactiveRestore()
{
  echo "ENSURE THAT CONTAINER IS STOPPED !, press enter to continue."
  echo
  read
  echo "Enter volume archive name to restore without extension neither path, like wordpress_volume_6h30m_050719"
  ls ${BCKDIR}
  read restoname
  echo "Enter volume name that is defined in docker application/container"
  read volrname
  cp -rp ${BCKDIR}/${restoname}.tar.bz2 /tmp/
  docker run -v ${volrname}:/volume -v /tmp:/backup --rm loomchild/volume-backup restore ${restoname}.tar.bz2
  rm -Rf /tmp/${restoname}.tar.bz2
  echo "$(date) ## Volume archive: ${restoname} was restored from ${BCKDIR}/${restoname}.tar.bz2 on ${volrname} docker volume ##"
  echo
  echo "You can now restart container(s)."
}
if [[ $1 == ibackup ]]
then
  interactiveBackup
elif [[ $1 == backup ]]
then
  if [ -z "$2" ]
  then
   echo "Volume name is missing, second argument must be the docker volume name"
   exit 1
  fi
  volname=${2}
  backup
elif [[ $1 == irestore ]]
then
  interactiveRestore
else
  echo "Bad argument, correct args: backup volname, ibackup (interactive backup) OR irestore (interactive restore)"
  exit 1
fi

# EOS

