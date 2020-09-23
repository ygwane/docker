#!/bin/bash
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock --name ctop quay.io/vektorlab/ctop:latest

