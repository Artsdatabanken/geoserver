ARG CODE_VERSION=latest
FROM kartoza/geoserver:${CODE_VERSION}

ARG pluginsDir=$CATALINA_HOME/webapps/geoserver/WEB-INF/lib/
ARG sqlServerPlugin=geoserver-${GS_VERSION}-sqlserver-plugin.zip
ARG vectortilesPlugin=geoserver-${GS_VERSION}-vectortiles-plugin.zip

RUN wget http://sourceforge.net/projects/geoserver/files/GeoServer/${GS_VERSION}/extensions/${vectortilesPlugin} && \
    unzip ${vectortilesPlugin} -d ${pluginsDir} && \
    rm ${vectortilesPlugin}

    # Consider updating protobuf
    # http://central.maven.org/maven2/com/google/protobuf/nano/protobuf-javanano/3.1.0/protobuf-javanano-3.1.0.jar

RUN wget http://sourceforge.net/projects/geoserver/files/GeoServer/${GS_VERSION}/extensions/${sqlServerPlugin} && \
    unzip ${sqlServerPlugin} -d ${pluginsDir} && \
    rm ${sqlServerPlugin} && \
    sqlJdbc=`curl -s https://api.github.com/repos/Microsoft/mssql-jdbc/releases/latest|grep browser_download_url|grep jre8.jar|cut -d: -f3` && \
    wget https:${sqlJdbc%?} -P ${pluginsDir}