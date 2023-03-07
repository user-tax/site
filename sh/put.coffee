> @u7/ossput
  ./ossLi.mjs

< (args...)=>
  put = ossput await ossLi(process.env.BUCKET_SITE)
  put ...args
