# 基础镜像
#FROM daocloud.io/library/java:8u40-jdk
FROM docker.m.daocloud.io/library/openjdk:8-jdk-alpine
LABEL authors="zhaoyu"

COPY mytest.jar /usr/local/
WORKDIR /usr/local
CMD java -jar mytest.jar
