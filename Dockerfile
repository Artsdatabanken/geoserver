ARG TOMCAT_EXTRAS=false
ARG CODE_VERSION=latest
FROM kartoza/geoserver:${CODE_VERSION}

ARG webInfDir=$CATALINA_HOME/webapps/geoserver/WEB-INF
ARG pluginsDir=${webInfDir}/lib/
ARG sqlServerPlugin=geoserver-${GS_VERSION}-sqlserver-plugin.zip
ARG vectortilesPlugin=geoserver-${GS_VERSION}-vectortiles-plugin.zip

# Vectortiles
RUN wget http://sourceforge.net/projects/geoserver/files/GeoServer/${GS_VERSION}/extensions/${vectortilesPlugin} && \
    unzip ${vectortilesPlugin} -d ${pluginsDir} && \
    rm ${vectortilesPlugin}

    # Consider updating protobuf
    # http://central.maven.org/maven2/com/google/protobuf/nano/protobuf-javanano/3.1.0/protobuf-javanano-3.1.0.jar

# SQL Server
RUN wget http://sourceforge.net/projects/geoserver/files/GeoServer/${GS_VERSION}/extensions/${sqlServerPlugin} && \
    unzip ${sqlServerPlugin} -d ${pluginsDir} && \
    rm ${sqlServerPlugin} && \
    sqlJdbc=`curl -s https://api.github.com/repos/Microsoft/mssql-jdbc/releases/latest|grep browser_download_url|grep jre8.jar|cut -d: -f3` && \
    wget https:${sqlJdbc%?} -P ${pluginsDir}

# Enable CORS
RUN perl -i -0777 -pe 's/<!--\s*?(<filter.*?cross-origin.*?\/filter>)\s*?-->/$1/s' ${webInfDir}/web.xml
RUN perl -i -0777 -pe 's/<!--\s*?(<filter-mapping.*?cross-origin.*?\/filter-mapping>)\s*?-->/$1/s' ${webInfDir}/web.xml