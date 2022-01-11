#!/bin/bash

read -p "请输入要格式化的磁盘名称(如：sdb、sdb等只输入单个磁盘设备名称)：" diskNAME
fdisk  /dev/$diskNAME < ./autoparting.txt
echo "--------------磁盘分区操作完成---------------"
part1=$diskNAME"1"
mkfs.ext4 /dev/$part1
echo $part1"------------分区格式化完成--------------"

while :
do
   read -p "请输入分区挂载目录（输入挂载目录绝对路径如：/data00、/home/opt等,目录自定义）：" mountPATH
   if [[ $mountPATH == /* ]];
   then
      if [ "$mountPATH" = "" ];
      then
         echo "默认挂载分区到/data00"
         mkdir -p /data00
         mount /dev/$part1 /data00
      else
         echo "挂载分区："$part1"到"$mountPATH"目录"
         mkdir -p $mountPATH
         mount /dev/$part1 $mountPATH
      fi
      break
   else
      echo "输入的信息不符合要求，请重启输入绝对路径"
   fi

done


