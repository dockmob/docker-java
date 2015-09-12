FROM alpine:3.2
MAINTAINER Nicola Ferraro <nibbio84@gmail.com>

RUN apk add --update openjdk7-jre && rm -rf /var/cache/apk/*

# Set DNS cache to 10 seconds (Cache is permanent by default). Network hosts are volatile in Docker clusters.
RUN grep '^networkaddress.cache.ttl=' /usr/lib/jvm/java-1.7-openjdk/jre/lib/security/java.security || echo 'networkaddress.cache.ttl=10' >> /usr/lib/jvm/java-1.7-openjdk/jre/lib/security/java.security
