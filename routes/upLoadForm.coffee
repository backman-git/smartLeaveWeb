express = require 'express'
router = express.Router()


fs = require 'fs'





# GET home page.
router.get '/', (req, res, next) ->

	res.send 'respond with a resource'


router.post '/',(req,res)->
	res.send "yes"

	urlToImage './uploadForms/image.png',req.body.image
	return 

module.exports = router



urlToImage = (path,url) ->

	data=url.replace /^data:image\/\w+;base64,/, ""

	#console.log url
	buf = new Buffer data, 'base64'
	fs.writeFile path,buf
	return 