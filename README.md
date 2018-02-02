# Powertrain


### Motivation

IoT/Time-Series usecases are common use cases on DSE and Cassandra. This demo was created to showcase how vehicle data or sensors could easily stream data from their machine to a Kafka Queue and be picked up by DSE Analytics. Once that data had been collected you could then use DSE Search and Analytics on both the columnar Cassandra data and data stored in DSE Graph.

### What is included?

This field asset includes the following DSE features

* Racing Game UI that streams vehicle events like crashes, start, and finishes to a Kafka Queue
* Spark Streaming job to collect vehicle data from Kafka and insert that data into Cassandra and DSE Graph
* DSE Search indexing on data for real-time insight on crash data
* Racing Leaderboard UI powered by DSE Graph and data pulled from GitHub

### Business Take Aways

Spark Streaming is one of our best tools for ingesting high velocity data and performing transformations on that datat. Having the knowledge of how Spark Streaming works and when to take advantage of it during an opportunity is incredibly valuable. Powertrain also takes advantage of DSE Graph and DSE Search and can be an example of using those features to enrich your data.

### Technical Take Aways

Passing data through something like a Kafka queue prevents your system from having to take the brunt of a large volume of messages at once. Essentially, this mechanism acts as a shock absorber and allows you to throttle a spiking workload into a more even ingest rate. Spark Streaming allows you to easily grab these messages via micro-batching and insert that data into other aspects of DSE such as Cassandra and DSE Graph. 

While DSE Search is not completely suited for a real-time analytics usecase like Elastic Search, you can still use it for some basic real-time aggregations and faceting. Similarly, DSE Graph allows us to store a network of GitHub users by collecting a GitHub username at login and then traversing your followers. We also collect top languages from each of your projects which allows us to put together a more personalized leaderboard based off followers and programming languages.

## Startup Script

This Asset leverages
[simple-startup](https://github.com/jshook/simple-startup). To start the entire
asset run `./startup all` for other options run `./startup`

For detailed docs [click here](https://github.com/phact/dsefs-demo/blob/master/docs/content/00_intro/introduction.md)