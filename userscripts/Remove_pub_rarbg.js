// ==UserScript==
// @name         BlockPubRarbg
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @require  http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js
// @require  https://gist.github.com/raw/2625891/waitForKeyElements.js
// @match        https://rarbgaccessed.org/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=rarbgaccessed.org
// @grant        GM_addStyle
// ==/UserScript==

waitForKeyElements ('a[href^="http"]', actionFunction);

function actionFunction (a) {

    let oldVal = a[0].href
    a[0].href = ""
    a[0].click()
    a[0].href = oldVal

}
