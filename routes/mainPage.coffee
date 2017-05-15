express = require 'express'
fs = require 'fs'

Node =require "../coffee/Node"
People =require "../coffee/People"
LeaveForm = require "../coffee/LeaveForm"
LeaveSystemSingleton = require '../coffee/LeaveSystemSingleton'
sessionManager = require '../coffee/SessionManager'
debug = require('debug') 'smartLeave:mainPage'
router = express.Router()











#-------------------------unhandle null---------------------------



router.get '/', (req, res, next) ->
	LSys = LeaveSystemSingleton.get()
	debug "LSys:"+LSys
	ID=req.cookies["ID"]
	name = sessionManager.getSessionName(ID)




	if ID  == sessionManager.getSessionID("假單庫")


		pNode=LSys.getPeopleNodeByName(name)
		pFormList=LSys.getPersonFormListByName(pNode["name"])
		pWList=pNode.getWaitHQueue()
		
		debug pWList

		res.render 'mainPage',
		mainScript: '../javascripts/MainUtility.js'
		name: pNode["name"],
		style: "./stylesheets/mainPage.css",
		historyList: pFormList,
		processList: pWList
		role:"personnel"

	else

		debug "general login"

		pNode=LSys.getPeopleNodeByName(name)
		debug "pNode:"+pNode
		pFormList=LSys.getPersonFormListByName(pNode["name"])
		pWList=pNode.getWaitHQueue()
		
		debug pWList

		res.render 'mainPage',
		mainScript: '../javascripts/MainUtility.js'
		name: pNode["name"],
		style: "./stylesheets/mainPage.css",
		historyList: pFormList,
		processList: pWList,
		role:"individual"







router.get '/editForm' , (req,res,next)->
	LSys = LeaveSystemSingleton.get()
	ID=req.cookies["ID"]
	name = sessionManager.getSessionName(ID)
	pNode=LSys.getPeopleNodeByName(name)


	if req.query.fID =="new"

		debug req.cookies["ID"]
		res.render 'formEditor',
		imgScript: '../javascripts/ImageUtility.js'
		mainScript: '../javascripts/MainUtility.js'
		form: "../images/form.png"
		style: "../stylesheets/editForm.css"
		team: pNode["team"]
		name: pNode["name"]
		title:pNode["title"]
		startCareerDay:pNode["startCareerDate"]
		availableDay:""+pNode["availableDay"]
		useDay:""+(pNode["useDay"]+1)
		role:"individual"
		markID:req.cookies["ID"]
		fID:0




	else 

		form=LSys.getFormByFID(req.query.fID)
		state= form.getState()


		if state['deputy'] is false

			res.render 'formEditor',
			imgScript: '../javascripts/ImageUtility.js'
			mainScript: '../javascripts/MainUtility.js'
			form: form.getImageUri()
			style: "../stylesheets/editForm.css"
			role:"deputy"
			markID:req.cookies["ID"]
			fID:form.getFID()
		

		#two type of form
		#type short
		else if form.getType() == 'short' and state['firstBoss'] is false	

			res.render 'formEditor',
			imgScript: '../javascripts/ImageUtility.js'
			mainScript: '../javascripts/MainUtility.js'
			form: form.getImageUri()
			style: "../stylesheets/editForm.css"
			role:"firstBoss"
			markID:req.cookies["ID"]
			fID:form.getFID()
			fType:form.getType()

		#type long
		else if form.getType() == "long" and state['firstBoss'] is false
			#firstBoss
			res.render 'formEditor',
			imgScript: '../javascripts/ImageUtility.js'
			mainScript: '../javascripts/MainUtility.js'
			form: form.getImageUri()
			style: "../stylesheets/editForm.css"
			role:"firstBoss"
			markID:req.cookies["ID"]
			fID:form.getFID()
			fType:form.getType()

		else if form.getType() == "long" and state['firstBoss'] is true and state['secondBoss'] is false 
			#secondBoss
			res.render 'formEditor',
			imgScript: '../javascripts/ImageUtility.js'
			mainScript: '../javascripts/MainUtility.js'
			form: form.getImageUri()
			style: "../stylesheets/editForm.css"
			role:"secondBoss"
			markID:req.cookies["ID"]
			fID:form.getFID()
			fType:form.getType()




		else 
			#personnel office
			res.render 'formEditor',
			imgScript: '../javascripts/ImageUtility.js'
			mainScript: '../javascripts/MainUtility.js'
			form: form.getImageUri()
			style: "../stylesheets/editForm.css"
			role:"personnel"
			markID:req.cookies["ID"]
			fID:form.getFID()


	
	


#upload
router.post '/uploadForm',(req,res)->





	LSys = LeaveSystemSingleton.get()


	ID=req.cookies["ID"]
	name = sessionManager.getSessionName(ID)
	fName=req.body.name.replace " ",""
	debug "upload By:"+name

	# new 填表人
	if name ==fName

		dt=genDate()
		#create data object LeaveForm("許木坤","20170101","楊文宏")



		newForm=new LeaveForm(fName,genDate(),req.body.deputyName,req.body.fType)
		newForm.setImageDir("dataPool/forms")
		fID=newForm.getFID()
		urlToImage newForm.getImagePath(),req.body.image



		LSys.addNewForm(newForm)

		LSys.submitFormByID(name,fID)
		LSys.showArchitecture()
		res.redirect("/mainPage")

	else
		form=LSys.getFormByFID(req.body.fID)
		
		if form isnt null
			urlToImage form.getImagePath(),req.body.image
			LSys.submitFormByID(name,form.getFID())
			LSys.showArchitecture()
			res.redirect("/mainPage")




	
	

	






module.exports = router


#============================

urlToImage = (path,url) ->

	data=url.replace /^data:image\/\w+;base64,/, ""

	#debug url
	buf = new Buffer data, 'base64'
	fs.writeFile path,buf
	return 



genDate =()->
	dt = new Date()
	year=dt.getFullYear()
	month=dt.getMonth()+1
	day=dt.getDate()
	h=dt.getHours()
	m=dt.getMonth() 
	sec=dt.getSeconds() 

	return year+"."+month+"."+day+"."+h+"."+m+"."+sec
