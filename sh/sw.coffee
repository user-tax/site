#!/usr/bin/env coffee

> ./s3.cdn:
  ./env > DIST
  ./put
  @u7/read
  path > join
  stream > Readable
  @u7/doge
  ./cloudflare

url = (i)=>i.slice(i.lastIndexOf('/')+1,-1)

do =>
  for i from read(join DIST,'index.htm').split('<')
    if i.startsWith('script ')
      script = url i
    else if i.startsWith('link ')
      css = url i
  if not css
    return
  txt = css+' '+script
  console.log 'v →',txt
  await put(
    'v'
    =>
      s = new Readable
      s.push txt
      s.push null
      s
    'text/css'
  )

  url = "https://usx.tax/v"
  console.log await Promise.all [
    cloudflare(
      "purge_cache"
      {
        files:[
          url
        ]
      }
    )
    doge(
      'cdn/refresh/add.json'
      {
        rtype: 'url'
        urls: JSON.stringify([
          'https://usr.tax/v'
        ])
      }
    )
  ]
  return
