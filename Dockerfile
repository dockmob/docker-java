FROM alpine:3.2
MAINTAINER Nicola Ferraro <nibbio84@gmail.com>
# Thanks to Anastas Dancha
# AlpineLinux with a glibc-2.21 and Oracle Java 8

# Install cURL
RUN apk --update add curl ca-certificates tar && \
    curl -Ls https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk > /tmp/glibc-2.21-r2.apk && \
    apk add --allow-untrusted /tmp/glibc-2.21-r2.apk

# Java Version
ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 60
ENV JAVA_VERSION_BUILD 27
ENV JAVA_PACKAGE       jre


# Download and unarchive Java
RUN mkdir /opt && curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie"\
  http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz \
    | tar -xzf - -C /opt &&\
    ln -s /opt/${JAVA_PACKAGE}1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/${JAVA_PACKAGE} &&\
    rm -rf /opt/${JAVA_PACKAGE}/*src.zip \
           /opt/${JAVA_PACKAGE}/lib/missioncontrol \
           /opt/${JAVA_PACKAGE}/lib/visualvm \
           /opt/${JAVA_PACKAGE}/lib/*javafx* \
           /opt/${JAVA_PACKAGE}/jre/lib/plugin.jar \
           /opt/${JAVA_PACKAGE}/jre/lib/ext/jfxrt.jar \
           /opt/${JAVA_PACKAGE}/jre/bin/javaws \
           /opt/${JAVA_PACKAGE}/jre/lib/javaws.jar \
           /opt/${JAVA_PACKAGE}/jre/lib/desktop \
           /opt/${JAVA_PACKAGE}/jre/plugin \
           /opt/${JAVA_PACKAGE}/jre/lib/deploy* \
           /opt/${JAVA_PACKAGE}/jre/lib/*javafx* \
           /opt/${JAVA_PACKAGE}/jre/lib/*jfx* \
           /opt/${JAVA_PACKAGE}/jre/lib/amd64/libdecora_sse.so \
           /opt/${JAVA_PACKAGE}/jre/lib/amd64/libprism_*.so \
           /opt/${JAVA_PACKAGE}/jre/lib/amd64/libfxplugins.so \
           /opt/${JAVA_PACKAGE}/jre/lib/amd64/libglass.so \
           /opt/${JAVA_PACKAGE}/jre/lib/amd64/libgstreamer-lite.so \
           /opt/${JAVA_PACKAGE}/jre/lib/amd64/libjavafx*.so \
           /opt/${JAVA_PACKAGE}/jre/lib/amd64/libjfx*.so \
           /opt/${JAVA_PACKAGE}/lib/plugin.jar \
           /opt/${JAVA_PACKAGE}/lib/ext/jfxrt.jar \
           /opt/${JAVA_PACKAGE}/bin/javaws \
           /opt/${JAVA_PACKAGE}/lib/javaws.jar \
           /opt/${JAVA_PACKAGE}/lib/desktop \
           /opt/${JAVA_PACKAGE}/plugin \
           /opt/${JAVA_PACKAGE}/lib/deploy* \
           /opt/${JAVA_PACKAGE}/lib/*javafx* \
           /opt/${JAVA_PACKAGE}/lib/*jfx* \
           /opt/${JAVA_PACKAGE}/lib/amd64/libdecora_sse.so \
           /opt/${JAVA_PACKAGE}/lib/amd64/libprism_*.so \
           /opt/${JAVA_PACKAGE}/lib/amd64/libfxplugins.so \
           /opt/${JAVA_PACKAGE}/lib/amd64/libglass.so \
           /opt/${JAVA_PACKAGE}/lib/amd64/libgstreamer-lite.so \
           /opt/${JAVA_PACKAGE}/lib/amd64/libjavafx*.so \
           /opt/${JAVA_PACKAGE}/lib/amd64/libjfx*.so



# Fix DNS resolution issues when nss is not installed
RUN echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

# Set DNS cache to 10 seconds (Cache is permanent by default). Network hosts are volatile in Docker clusters.
RUN grep '^networkaddress.cache.ttl=' /opt/${JAVA_PACKAGE}/lib/security/java.security || echo 'networkaddress.cache.ttl=10' >> /opt/${JAVA_PACKAGE}/lib/security/java.security


# Set environment
ENV JAVA_HOME /opt/${JAVA_PACKAGE}
ENV PATH ${PATH}:${JAVA_HOME}/bin

CMD java -version