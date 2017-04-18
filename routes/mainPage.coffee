express = require 'express'
fs = require 'fs'

Node =require "../coffee/Node"
People =require "../coffee/People"
LeaveForm = require "../coffee/LeaveForm"
LSysSingleton = require '../coffee/leaveSystemSingleton'
router = express.Router()






# only for test should use in dataBase
users = {'人事室': {username: '假單庫',password: '123',id:'0'}, '許木坤': {username: '許木坤',password: '1',id: '101'},'林子博': {username: '林子博',password: '5',id: '202'},'楊文宏': {username: '楊文宏',password: '2',id: '303'}}
idTable={'101':"許木坤",'202':"林子博",'303':"楊文宏",'0':"假單庫"}





#----------------------------------------------------
LSys = LSysSingleton.get()


router.get '/', (req, res, next) ->

	ID=req.cookies["ID"]
	#BX should change
	name = idTable[ID]

	if ID  == users['人事室']['id']
		#if want change control page
		pNode=LSys.getPeopleNodeByName(name)
		pFormList=LSys.getPersonFormListByName(pNode["name"])
		pWList=pNode.getWaitHQueue()
		
		console.log pWList

		res.render 'mainPage',
		mainScript: '../javascripts/MainUtility.js'
		name: pNode["name"],
		style: "./stylesheets/mainPage.css",
		historyList: pFormList,
		processList: pWList
		role:"personnel"

	else
		pNode=LSys.getPeopleNodeByName(name)
		pFormList=LSys.getPersonFormListByName(pNode["name"])
		pWList=pNode.getWaitHQueue()
		
		console.log pWList

		res.render 'mainPage',
		mainScript: '../javascripts/MainUtility.js'
		name: pNode["name"],
		style: "./stylesheets/mainPage.css",
		historyList: pFormList,
		processList: pWList,
		role:"individual"







router.get '/editForm' , (req,res,next)->
	#BX
	name = idTable[req.cookies["ID"]]
	pNode=LSys.getPeopleNodeByName(name)



	if req.query.fID =="new"

				
		res.render 'formEditor',
		imgScript: '../javascripts/ImageUtility.js'
		mainScript: '../javascripts/MainUtility.js'
		form: "../images/form.png"
		style: "../stylesheets/editForm.css"
		name: pNode["name"]
		startCareerDay:pNode["startCareerDate"]
		availableDay:pNode["availableDay"]
		useDay:1
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
		else if state['boss'] is false	

			res.render 'formEditor',
			imgScript: '../javascripts/ImageUtility.js'
			mainScript: '../javascripts/MainUtility.js'
			form: form.getImageUri()
			style: "../stylesheets/editForm.css"
			role:"boss"
			markID:req.cookies["ID"]
			fID:form.getFID()

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

	name = idTable[req.cookies["ID"]]
	fName=req.body.name.replace " ",""
	console.log "uploadform---------------------\n\n\n"
	console.log name

	# new 填表人
	if name ==fName

		dt=genDate()
		#create data object LeaveForm("許木坤","20170101","楊文宏")
		newForm=new LeaveForm(fName,genDate(),req.body.deputyName)
		newForm.setImageDir("dataPool/forms")
		fID=newForm.getFID()
		urlToImage newForm.getImagePath(),req.body.image
		LSys.addNewForm(newForm)
		LSys.submitFormByID(name,fID)
		#LSys.showArchitecture()
		res.redirect("/mainPage")

	else
		form=LSys.getFormByFID(req.body.fID)
		
		console.log form
		if form isnt null
			urlToImage form.getImagePath(),req.body.image
			LSys.submitFormByID(name,form.getFID())
			LSys.showArchitecture()
			res.redirect("/mainPage")




	
	

	






module.exports = router


#============================

urlToImage = (path,url) ->

	data=url.replace /^data:image\/\w+;base64,/, ""

	#console.log url
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

	return year+""+month+""+day+""+h+""+m+""+sec
