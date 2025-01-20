FROM ubuntu:latest
LABEL authors="zhaoyu"

ENTRYPOINT ["top", "-b"]