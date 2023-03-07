<template lang="pug">
main
  nav
    a(href="/") User.Tax
    u-menu(@&menu)
      a
        i-t SIGN_IN
      | /
      a
        i-t.up SIGN_UP
    u-i18n
  .auth
    header
      b.logo
      b.org
        b User.Tax
        b
          i-slogan
    u-sign
</template>

<script lang="coffee">
> ./conf > API USER_TAX_CDN
  ./i18n.js:
  user.tax/_/Box
  user.tax/_/SDK > init
  user.tax/_/lang
  user.tax/user/Auth.agree:AuthAgree
  user.tax/user/Sign.auth:SignAuth
  user.tax/user/WAY > waySet
  user.tax/user/WAY/MAIL
  user.tax/user/i18n/var > ver
  user.tax:
  svelte > onMount

init API, USER_TAX_CDN
waySet(MAIL)


boxAuth = (e) =>
  box = Box(
    '<div class="auth"><header><b class="logo"></b><b class="org"><b>User.Tax</b><b><i-slogan></i-slogan></b></b></header><u-auth></u-auth></div>',
  )
  Object.assign(box.getElementsByTagName("u-auth")[0], {
    up: "up" == e?.target.className,
    next: box.close.bind(box),
  })
  box

+ menu

onMount =>
  menu.querySelectorAll("u-menu a").forEach (e) =>
    e.onclick = (e) =>
      e.preventDefault()
      boxAuth(e)
      return

SignAuth(boxAuth)

AuthAgree =>
  dialog = Box(
    '<div style="padding:0 1.8em 2em;height:calc(100vh - 8em);"><b style="height:100%;justify-content:center;display:flex;align-items:center"><svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 100 100"><circle cx="50" cy="50" fill="none" stroke="#ccc" stroke-width="10" r="35" stroke-dasharray="164.93361431346415 56.97787143782138"><animateTransform type="rotate" repeatCount="indefinite" dur="1s" values="0 50 50;360 50 50" keyTimes="0;1" attributeName="transform"/></circle></svg></b></div>',
  )
  [md, marked] = await Promise.all([
    (=> (await fetch(USER_TAX_CDN + "user/#{ver}/law." + lang())).text())(),
    import("//cdn.bootcdn.net/ajax/libs/marked/4.2.12/lib/marked.esm.min.js")
  ])
  dialog.lastChild.innerHTML = marked.parse(md)
  dialog.style = "width:85vw;max-width:750px"
  return

</script>

<style lang="stylus">
@import 'styl/body.styl';
@import 'styl/auth.styl';
</style>

