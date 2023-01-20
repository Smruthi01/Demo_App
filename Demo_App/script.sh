#!/bin/bash
# version: 0.2
# phases:
#   install:
#     runtime-versions:
#       java: corretto8
#   pre_build:
#     commands:
#     - echo In the pre_build phase...
#   build:
#     commands:
#     - echo Build started on `date`
#   post_build:
#     commands:
#     - echo Build completed on `date`
#     - mvn package
#     - mv target/bike-service-0.0.1-SNAPSHOT.war bike-service-0.0.1-SNAPSHOT.war
# artifacts:
#   files:
#   - bike-service-0.0.1-SNAPSHOT.war
#   - .ebextensions/**/*
