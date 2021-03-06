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

		res.render 'mainPage/',
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
		name: pNode["name"].replace(pNode["team"]+"-","")
		title:pNode["title"]
		startCareerDay:pNode["startCareerDate"]
		availableDay:""+pNode["availableDay"]
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
			editor:sessionManager.getSessionName(req.cookies["ID"])
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
			editor:sessionManager.getSessionName(req.cookies["ID"])
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
			editor:sessionManager.getSessionName(req.cookies["ID"])
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
			editor:sessionManager.getSessionName(req.cookies["ID"])
			fID:form.getFID()
			fType:form.getType()




		else 
			#personnel office

			applicant=LSys.getPeopleNodeByName(form.getOwner())
			nUseDay= parseInt(applicant.useDay)
			debug "useDay: "+nUseDay+","+parseInt(applicant.useDay)+","+parseInt(form.reqDay)+","+applicant
			res.render 'formEditor',
			imgScript: '../javascripts/ImageUtility.js'
			mainScript: '../javascripts/MainUtility.js'
			form: form.getImageUri()
			style: "../stylesheets/editForm.css"
			role:"personnel"
			useDay:""+nUseDay
			markID:req.cookies["ID"]
			editor:sessionManager.getSessionName(req.cookies["ID"])
			fID:form.getFID()




router.post '/cancelForm',(req,res)->

	debug req.body.name,req.body.fID

	if req.body.name? and req.body.fID?
		LSys = LeaveSystemSingleton.get()
		LSys.cancelFormByID(req.body.name,req.body.fID)
		form=LSys.getFormByFID(req.body.fID)
		debug form.getState()


	res.redirect("/mainPage")





#upload
router.post '/uploadForm',(req,res)->





	LSys = LeaveSystemSingleton.get()


	ID=req.cookies["ID"]
	name = sessionManager.getSessionName(ID)
	fName=req.body.name.replace " ",""
	debug "upload By:"+name



	#check if deputyName exist?
	if req.body.deputyName?
		pNode=LSys.getPeopleNodeByName(req.body.deputyName)
		if pNode  == null and req.body.fID=="0"	
			res.send("指定代理人不存在")






		# new 填表人
		else if name.indexOf(fName) != -1

			dt=genDate()
			#create data object LeaveForm("許木坤","20170101","楊文宏")


			newForm=new LeaveForm(name,genDate(),req.body.deputyName,req.body.fType,req.body.reqDay)
			newForm.setImageDir("dataPool/forms")
			fID=newForm.getFID()
			urlToImage newForm.getImagePath(),req.body.image



			LSys.addNewForm(newForm)
			LSys.submitFormByID(name,fID)
			#LSys.showArchitecture()

			res.redirect("/mainPage")

	else
		form=LSys.getFormByFID(req.body.fID)		
		if form isnt null
			urlToImage form.getImagePath(),req.body.image
			LSys.submitFormByID(name,form.getFID())
			#LSys.showArchitecture()
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

	return year+"_"+month+"_"+day+"_"+h+"_"+m+"_"+sec
