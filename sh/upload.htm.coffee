#!/usr/bin/env coffee

> ./env > DIST
  ./mime
  ./put
  ./s3.ali:
  @u7/walk > walkRel
  fs > createReadStream
  path > join

for await i from walkRel DIST
  console.log i
  await put(
    i
    =>
      createReadStream join(DIST, i)
    mime i
  )
