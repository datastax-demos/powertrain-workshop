---
title: Script
menu:
  main:
      parent: Script
      identifier: script
      weight: 201
---

### Race

The race car app is available at  http://<host>:9000/game/index.html on the seed node.

The UI wil promt the user for their github ID.
Type in your ID and click Let's Play.
We use this ID to populate the user's github data into the graph.
This enables us to perform graph queries that are contextual to the user.

Once the user's github has been populated the race can begin.
To race use the arrow keys to steer and accelerate and the A and D keys to break.
The goal of the game is to complete three laps in the lowest possible time.
Your shields are damaged if you hit the walls of the track and sometimes it is possible to fall off the track entirely!
If you depleat your shields or fall off the game is over.

One person can play the game or multiple can play simultaneously on their mobile devices.
You can drive by using your fingers on the right and left side of the screen on mobile touchscreens.
The right finger stears by sliding around the right half of the screen and left finger is the gas by touching and releasing the left half of the screen.

As the user is racing notice that the backend gets data every second (x, y, and z coordinates), speed, acceleration, etc. as well as events when the user crashes, completes a lap, or gets destroyed.

You can see the data flowing by looking at your javascript console.

### Results

Once users have raced, the data is published to Kafka, crunched by spark streaming, and persisted to DSE.
Go to the Powertrain Viewer (port 8081 on your seed node) to see a geographic representation of the races in th system.

Kepler.gl allows you to fetch data in real time using the fetch button and to manipulate the visualization using the kepler.gl panel when the visualization is paused.

Finally, go to the Studio notebook to perform some cql, gremlin, or sparksql queries on the data.
