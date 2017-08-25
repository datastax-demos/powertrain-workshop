+++
date = "2017-04-10T14:21:00-05:00"
title = "Architecture"
weight = 6
+++

This section details the architecture demonstrated in this reference field asset.

### Architecture Diagram

<div title="rendered dynamically" align="middle">
{{< mermaid >}}
graph LR
B--"Checkpointing"-->E
C["Client"]
A["Queue"]--"Streaming Ingest"-->B["DSE Streaming Analytics"]
B--"microbatches"-->C["DSE Cassandra"]
E["DSEFS"]--"Load"-->C
C--"Unload"-->E
{{< /mermaid >}}
</div>

### Architecture

DSEFS can be used for loading / unloading data from C* and for checkpointing during spark streaming jobs.
