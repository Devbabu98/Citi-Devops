File name instruction.sh for linux

# ----------------- hostname check---------------
#rm /tmp/$1/hostname

hostname  > /tmp/$1/hostname.txt
export HOSTNAME='cat /tmp/$1/hostname.txt'

env=none
if [ $HOSTNAME = 'servename_dev1'] || [ $HOSTNAME= 'srvername1.nam.nsroot.net' ]  ||
  [ $HOSTNAME = 'servename_dev2'] || [ $HOSTNAME= 'srvername2.nam.nsroot.net' ]

then 
env=Dev
profile=DEV
type=ip

fi

if [ $HOSTNAME = 'servename_dev1'] || [ $HOSTNAME= 'srvername1.nam.nsroot.net' ]

then 
env=Dev
profile=DEV
type=ip

fi

if [ $HOSTNAME = 'servename_UAT'] || [ $HOSTNAME= 'srvername_UAT.nam.nsroot.net' ]

then 
env=UAT
profile=UAT
type=ip

fi
if [ $HOSTNAME = 'servename_Prod'] || [ $HOSTNAME= 'srvername_prod.nam.nsroot.net' ]

then 
env=Prod
profile=PROD
type=ip

fi

# define all the the environment and server here

#------------------apply changes ---------

VERSION_INI=/tmp/$1/package/version.ini
perl -pi -e 's/\r\n/\n/g' $VERSION_INI

while IFS='=' read r key value
do
key=#(echo $key | tr '.''_')
#remove all whitespace
value= "$(echo -e "${value}" | tr -d '[:space:]')"
eval "${key}=${value}"
done < "$VERSION_INI"

echo environment is ${env}
echo server is ${HOSTNAME}
echo Release label is ${release_label}

Release_docs=/tmp/$1/Releasedocs
SOURCE_DIR=/tmp/$1/package
INSTALL_SCRIPT=/tmp/$1/installscript
VERSION_INI=/tmp/$1/package/version.ini

DEPLOY_LIST_FILE=$INSTALL_SCRIPT/udeploy.file.txt
MAIN_DIR=/SERVERPATH
PAKCAGE_DIR=/tmp/$1/package

######################################################################################################################
echo "calling predeployment script --> $INSTALL_SCRIPT/manualinstruction.sh $1 $release _label"

$INSTALL_SCRIPT/manualinstruction.sh $1 $release_label

######################################################################################################################

echo " taking backup ..........coping files............setting permission"

echo coping Release files from $SOURCE_DIR to $MAIN_DIR

echo "**************************************file loop start *********************

while read -r line; do
    s="${line//\\//}
    s=${s//[$'\r\n'.]}
TARGET_DIR=$MAIN_DIR
SOURCE_DIR=PAKCAGE_DIR

if test -z $S
 then 
 echo lien is empty.

elif test -f SOURCE_DIR.$s
then
filecontent=$(echo ${/s///,} | tr "," "\n")

for content in $filecontent
do 
 content=${content//[$'\r\n']}

if test -d $SOURCE_DIR/$content
then

     if [ -d "$TARGET_DIR/$content" ]; then
      TARGET_DIR=$TARGET_DIR/$content
      SOURCE_DIR=$SOURCE_DIR/$content
     else
      cd $TARGET_DIR
      mkdir $content
      chmod 755 $content
   T  ARGET_DIR=$TARGET_DIR/$content
      SOURCE_DIR=$SOURCE_DIR/$content
      echo "created Directory " $TARGET_DIR/$content
    fi

elif test -f $SOURCE_DIR/$content
 then
  echo "$content is file"
   if [ -f $TARGET_DIR/$content ] ; then
      if [ -f "$TARGET_DIR/$content$$release_label" ]; then
         mv $TARGET_DIR/$content $TARGET_DIR/$content$release_label$(date "+%y%m%d%H%M%S")
         echo "backup_file= $TARGET_DIR/$content$release_labe$(date "+%y%m%d%H%M%S")
      else 
         mv TARGET_DIR/$content $TARGET_DIR/$content$release_label
         echo "backup_file= $TARGET_DIR/$content$release_label"
      fi
        cp "$SOURCE_DIR/$content" "$TARGET_DIR/$content"
        chmod 755 "TARGET_DIR/$content"
        doc2unix $TARGET_DIR/$content
        echo "file copied $TARGET_DIR/$content"
      else
        cp "$SOURCE_DIR/$content" "$TARGET_DIR/$content"
        chmod 755 "$TARGET_DIR/$content"
        doc2unix $TARGET_DIR/$content
        echo "file copied $TARGET_DIR/$content"
       fi
    fi
 done
else "$s is not valid"
fi

done < $DEPLOY_LIST_FILE
echo "********************************Deployment completed *******************************"

#######################################################################################################################


