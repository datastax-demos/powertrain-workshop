cp ~/.ssh/id_rsa .
docker build -t powertrain .
docker run \
  --net=host -d  \
  -p 0.0.0.0:9000:9000 \
  -p 0.0.0.0:9092:9092 \
  --powertrain powertrain