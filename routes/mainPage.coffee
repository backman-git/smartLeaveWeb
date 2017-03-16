express = require 'express'
router = express.Router()

# GET home page.
router.get '/', (req, res, next) ->
  res.render 'mainPage',
  style: "./stylesheets/mainPage.css"

module.exports = router
