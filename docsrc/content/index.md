---
title: Powertrain Demo
type: index
weight: 0
---

This asset is designed as an art of the possible demonstration to show real time data streaming into DSE analytics for both cql and graph. The UI is a video game that generates the data. Finally, we are able to visualize the resulting geo data in a 3d map.

### Motivation

DSE is the perfect backend for a real time mission critical application. The Powertrain demo is an example application that leverages most of the main capabilities within DSE.
Users can ideate how the real time capabilities leveraged in Powertrain can be leveraged in their industries to tackle real business problems.

### What is included?

This field asset (demo) includes the following:

* HTML5 race car app
* Play framework web backend
* Spark streaming
* DSE Graph
* DSE Analytics
* DSE Search
* 3d Map Visualization

### Business Take Aways

Modern Applications require the 5 Dimensions to satisfy business needs.
The Powertrain demo demonstrates how a video game's real-time and contextual requirements can be satisfied by using DSE search, analytics, and graph.

### Technical Take Aways

The HTML5 race car video game (mobile compatible) communicates with the Scala Play Framework application via web sockets (push).
The real time streaming data is published to a Kafka queue.


DSE Analytics is used to run a Spark streaming application that listens to the Kafka queue, processes the data and writes cql metrics to DSE and contextual data to DSE graph using gremlin.
To view the results of the race car data we use a 3d representation of the data powered by deck.gl and kepler.gl.
