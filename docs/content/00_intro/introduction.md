+++
date = "2017-04-10T14:21:00-05:00"
title = "Introduction"
weight = 1
+++

This is a guide for how to use the power tools dsefs asset brought to you by the Vanguard team.

### Motivation

DSEFS is a relatively new part of DSE with particularly useful capabilities within the analytics space. The purpose of DSEFS is to prevent the need for DSE users with needs for a basic distributed file system to satisfy some of their real time DSE powered workloads from having to go install HDFS / call in a hadoop vendor. This asset is meant to demonstrate the basic capabilities of DSEFS.

### What is included?

This field asset includes sample usage of DSEFS in the following contexts:

* Puts and gets (without Spark)
* Puts and gets with Spark
* DSEFS loading, unloading, and joining to, from, and with Cassandra
* DSEFS for checkpointing of Spark Streaming jobs

### Business Take Aways

When a use case arises that requires a distributed filesystem, customers do not necesarlily have to get a third party hadoop vendor involved. Most of these cases can be covered by DSEFS.

Our intention is not to try to enter the hadoop market, but rather to ease the use cases that are mostly DSE powered but require a distributed file system as well.

### Technical Take Aways

Unlike it's precursor CFS, DSEFS stores the file data (sblocks) in the file system of the nodes in the cluster. It stores the file metatdata (inodes) in cassandra. CFS used to store both inodes and sblocks in cassandra leading to undesirable performance issues related to compactions, tombstones, and read and write throughput. The file system locations used by DSEFS are configurable in the dse.yaml and should be separate volumes than the cassandra data directory. DSEFS volumes can achieve significantly higher densities than cassandra since predictable latencies are less of an option. Up to 20TB per node is a good place to start.

DSEFS was designed to run with comparable (ballpark) performance to HDFS. As expected with a distributed file system, DSEFS performs better in therms of throughput with larger files than smaller files. When interacting with DSEFS programatically (today) we need to import denendencies from `dse.jar`. This will not always be the case as they will be added to the spark dependencies in artifactory, stay tuned.

These docs will dive deeper on the following functionality:

- Puts and Gets
- Spark dsefs interactions
- Checkpointing
