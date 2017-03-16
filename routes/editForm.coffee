express = require 'express'
router = express.Router()

# GET home page.
router.get '/', (req, res, next) ->
  res.render 'editForm',
    script: './javascripts/ImageUtility.js'
    form: "./images/form.png"
    style: "./stylesheets/editForm.css"

module.exports = router
