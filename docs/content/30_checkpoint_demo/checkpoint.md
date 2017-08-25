+++
date = "2017-04-10T14:21:00-05:00"
title = "Checkpointing"
weight = 2
+++

The most common use case for DSEFS is spark streaming checkpointing.

### GIF

Enjoy this animated gif of the functionality in the demo:

![checkpointing](/30_checkpoint_demo/checkpoint-demo.gif)

### Relevant docs

Zookeeper is not relied on for offsets anymore
https://issues.apache.org/jira/browse/SPARK-12177

See the docs on spark / kafka integration for details regarding the specific Kafka APIs
http://spark.apache.org/docs/latest/streaming-kafka-0-10-integration.html#storing-offsets
