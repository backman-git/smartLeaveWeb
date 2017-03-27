express = require 'express'
router = express.Router()

# GET home page.
router.get '/', (req, res, next) ->
  res.render 'editForm',
    script: './javascripts/ImageUtility.js'
    form: "./images/form.png"
    style: "./stylesheets/editForm.css"
    name:"陳郁彥"
    FID:"123"
    markID: 1
    startCareerDay:"2017/01/01"
    availableDay:200
    useDay:199

module.exports = router
