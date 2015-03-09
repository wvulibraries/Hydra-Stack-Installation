#!/bin/bash

EXIT_MISSING_ARGS=-1

# Make sure we have a command line arg
if [ ! -n "$1" ]
        then
        echo;echo "Usage: createSolrCollection.sh solrName";echo
        exit $EXIT_MISSING_ARGS
fi

# Using the install scripts, run as root, this is where it ends up
# Not sure why it isn't in /opt/hydrastack/install
PATH_TO_SOLR_DOWNLOAD="/root/solr-4.6.1"

# Make the directory tree
mkdir -p $SOLR_INSTALL_DIR/$1/lib

# copy the .war and .jar files 
cp $PATH_TO_SOLR_DOWNLOAD/dist/solr-4.6.1.war $SOLR_INSTALL_DIR/$1
cp $PATH_TO_SOLR_DOWNLOAD/dist/*.jar $SOLR_INSTALL_DIR/$1/lib
cp -r $PATH_TO_SOLR_DOWNLOAD/contrib $SOLR_INSTALL_DIR/$1/lib
cp -r $PATH_TO_SOLR_DOWNLOAD/example/solr/collection1 $SOLR_INSTALL_DIR/$1/collection1
cp $SOLR_INSTALL_DIR/$1/collection1/conf/lang/stopwords_en.txt $SOLR_INSTALL_DIR/$1/collection1/conf/

# create the project xml file
cat > $SOLR_INSTALL_DIR/$1/$1.xml <<EOF
<?xml version="1.0" encoding="utf-8"?>
<Context docBase="%%SOLR_INSTALL_DIR%%/%%absolute%%/solr-4.6.1.war" debug="0" crossContext="true">  
    <Environment name="solr/home" type="java.lang.String" value="%%SOLR_INSTALL_DIR%%/%%absolute%%" override="true"/>  
</Context>
EOF

sed -i "s@%%SOLR_INSTALL_DIR%%@$SOLR_INSTALL_DIR@g" $SOLR_INSTALL_DIR/$1/$1.xml
sed -i "s@%%absolute%%@$1@g" $SOLR_INSTALL_DIR/$1/$1.xml

# chown $SOLR_INSTALL_DIR
chown -R tomcat:tomcat $SOLR_INSTALL_DIR

# simlink tomcat to the solr xml file
ln -sf $SOLR_INSTALL_DIR/$1/$1.xml /etc/tomcat/Catalina/localhost/$1.xml

# restart tomcat
systemctl restart tomcat

# TODO "hostname should be pulled from env"
echo "Test installation at http://hostname:8080/$1/"