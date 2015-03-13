#!/usr/bin/env bash
set -e

if [ "$EUID" -ne "0" ] ; then
        echo "Script must be run as root." >&2
        exit 1
fi

# check necessary variables
#if $HYDRA_NAME doesn't exist solr-4.6.1
#then
#abort
#else
#continue
#fi

# get the solr installer
cd $HYDRA_INSTALL_DIR
wget -q -c http://archive.apache.org/dist/lucene/solr/4.6.1/solr-4.6.1.tgz
tar xvzf solr-4.6.1.tgz

# check the /opt directory
ls -la $HYDRA_STACK_DIR
# pull environment variables
source /etc/environment
# check that hydra_name exists
echo $HYDRA_NAME

# make the working solr directories
mkdir -p $SOLR_INSTALL_DIR $SOLR_INSTALL_DIR/$HYDRA_NAME $SOLR_INSTALL_DIR/$HYDRA_NAME/lib
ls -la $SOLR_INSTALL_DIR

# copy the .war and .jar files 
cp ./solr-4.6.1/dist/solr-4.6.1.war $SOLR_INSTALL_DIR/$HYDRA_NAME
cp ./solr-4.6.1/dist/*.jar $SOLR_INSTALL_DIR/$HYDRA_NAME/lib
cp -r ./solr-4.6.1/contrib $SOLR_INSTALL_DIR/$HYDRA_NAME/lib
cp -r ./solr-4.6.1/example/solr/collection1 $SOLR_INSTALL_DIR/$HYDRA_NAME/collection1
cp $SOLR_INSTALL_DIR/$HYDRA_NAME/collection1/conf/lang/stopwords_en.txt $SOLR_INSTALL_DIR/$HYDRA_NAME/collection1/conf/
# for v 4.3 
cp ./solr-4.6.1/example/lib/ext/*.jar /usr/share/tomcat/lib/ 
cp ./solr-4.6.1/example/cloud-scripts/log4j.properties /usr/share/tomcat/lib/

# create the project xml file
cat > $SOLR_INSTALL_DIR/$HYDRA_NAME/$HYDRA_NAME.xml <<EOF
<?xml version="1.0" encoding="utf-8"?>
<Context docBase="%%SOLR_INSTALL_DIR%%/%%absolute%%/solr-4.6.1.war" debug="0" crossContext="true">  
    <Environment name="solr/home" type="java.lang.String" value="%%SOLR_INSTALL_DIR%%/%%absolute%%" override="true"/>  
</Context>
EOF

sed -i "s@%%SOLR_INSTALL_DIR%%@$SOLR_INSTALL_DIR@g" $SOLR_INSTALL_DIR/$HYDRA_NAME/$HYDRA_NAME.xml
sed -i "s@%%absolute%%@$HYDRA_NAME@g" $SOLR_INSTALL_DIR/$HYDRA_NAME/$HYDRA_NAME.xml

# chown $SOLR_INSTALL_DIR
chown -R tomcat:tomcat $SOLR_INSTALL_DIR

# simlink tomcat to the solr xml file
ln -sf $SOLR_INSTALL_DIR/$HYDRA_NAME/$HYDRA_NAME.xml /etc/tomcat/Catalina/localhost/$HYDRA_NAME.xml

# restart tomcat
systemctl restart tomcat

# TODO "hostname should be pulled from env"
echo "Test installation at http://hostname:8080/$HYDRA_NAME/"