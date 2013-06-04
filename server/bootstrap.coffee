Meteor.startup ->
  require = Npm.require
  path = require("path")
  fs = require('fs')
  base = path.resolve(".")
  isBundle = fs.existsSync(base + "/bundle")
  modulePath = base + ((if isBundle then "/bundle/static" else "/public")) + "/node_modules"
  
  #3rd party node packages in public/node_modules
  root.svg2png = require(modulePath + "/svg2png")