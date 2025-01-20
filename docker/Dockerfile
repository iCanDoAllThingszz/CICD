# 基础镜像
FROM daocloud.io/library/java:8u40-jdk
LABEL authors="zhaoyu"

COPY mytest.jar /usr/local/
WORKDIR /usr/local
CMD java -jar mytest.jar