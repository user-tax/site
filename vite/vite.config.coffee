import { join,dirname } from 'path'
import {coffee_plus} from 'coffee_plus'
import coffeescript from 'coffeescript'
import { merge } from 'lodash-es'
import vitePluginStylusAlias from './plugin/vite-plugin-stylus-alias.mjs'
import pug from 'pug'
import { defineConfig } from 'vite'

import sveltePreprocess from '@u7/svelte-preprocess'
import { svelte } from '@sveltejs/vite-plugin-svelte'
IGNORE_WARN = new Set(
  'a11y-click-events-have-key-events a11y-missing-content'.split(' ')
)

import thisdir from '@u7/uridir'
import { writeFileSync,renameSync } from 'fs'
import import_pug from './plugin/pug.js'

compile = coffee_plus(coffeescript)

ROOT = thisdir(import.meta)
DIST = join ROOT,'dist'
SRC = join ROOT,'src'
FILE = join ROOT,'file'

INDEX_HTML = 'index.html'
SRC_INDEX_HTML = join SRC,INDEX_HTML
writeFileSync(
  SRC_INDEX_HTML
  pug.compileFile(join SRC, 'index.pug')({
  })
)
host = '0.0.0.0' or env.VITE_HOST
port = 5555 or env.VITE_PORT


PRODUCTION = process.env.NODE_ENV == 'production'

config = {
  publicDir: join ROOT, 'public'
  plugins: [
    {
      name: 'coffee2'
      transform: (code, id) ->
        if not id.endsWith '.coffee'
          return
        try
          out = compile code,
            filename:  id
            bare:      true
            sourceMap: true
        catch err
          throw err

        code: out.js
        map:  out.v3SourceMap
    }
    svelte(
      onwarn:(warn)=>
        {code,message} = warn
        if code == 'a11y-missing-attribute'
          return !message.includes('<a>')
        !IGNORE_WARN.has code
      preprocess: [
        sveltePreprocess(
          coffeescript: {
            label:true
            sourceMap: true
          }
          #customElement:true
          stylus: true
          pug: true
        )
      ]
    )
    vitePluginStylusAlias()
    import_pug()
  ]
  clearScreen: false
  server:{
    host
    port
    strictPort: true
    ###
    proxy:
      '^/[^@.]+$':
        target: "http://#{host}:#{port}"
        rewrite: (path)=>'/'
        changeOrigin: false
    ###
  }
  resolve:
    alias:
      ":": join(ROOT, "file")
      '~': SRC
  esbuild:
    charset:'utf8'
    legalComments: 'none'
    treeShaking: true
  root: SRC
  build:
    outDir: DIST
    rollupOptions:
      input:
        index:SRC_INDEX_HTML
    target:['chrome110']
    assetsDir: '/'
    emptyOutDir: true
}

config = merge config, await do =>
  if PRODUCTION
    FILENAME = '[name].[hash].[ext]'
    JSNAME = '[name].[hash].js'

    return {
      plugins:[
        (await import('./plugin/mini_html.js')).default
      ]
      base: '//usr.tax/'
      build:
        rollupOptions:
          output:
            chunkFileNames: JSNAME
            assetFileNames: FILENAME
            entryFileNames: "m.js"
    }
  else
    return {
      plugins:[
        {
          name:'html-img-src'
          transformIndexHtml:(html)=>
            html.replaceAll(
              'src=":/'
              'src="/@fs'+FILE+'/'
            )
        }
      ]
    }


export default =>
  defineConfig config
