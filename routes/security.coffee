express = require 'express'
router = express.Router()


SM =require "../coffee/SecurityManager"

debug = require('debug') 'smartLeave:security'

router.get '/', (req, res, next) ->
	
	res.render "security",
	mainScript: '../javascripts/securityQR.js',
	style: '../stylesheets/SQR.css'



router.get "/sendCertification",(req,res,next)->

	if req.query.app =="BXDESIGN9999"
		SM.sendCertification(req.query.phoneID,req.query.tagID)
		res.setHeader('Content-Type', 'application/json')
		res.send(JSON.stringify({ status:"ok" }))
	else
		res.send(JSON.stringify({ status:"error" }))




router.get "/QRTag",(req,res,next)->

	res.setHeader('Content-Type', 'application/json')	
	tagID=SM.getTagID()

	#tag with URL
	debug tagID
	res.send(JSON.stringify({"QRImgPath":"code"+tagID+".png" ,tagID:""+tagID}))


router.get "/getAccount",(req,res,next)->
	
	#tempolate
	debug req.query.tagID
	account=SM.queryAccount(""+req.query.tagID)

	
	res.setHeader('Content-Type', 'application/json')
	res.send(JSON.stringify(account))




module.exports = router


