express = require 'express'
router = express.Router()
#------passport--
Passport = require('passport')
LocalStrategy = require('passport-local').Strategy  
session = require('express-session')  

LeaveSystemSingleton = require '../coffee/LeaveSystemSingleton'
sessionManager = require '../coffee/SessionManager'


db= require('../coffee/db')
People = require '../coffee/People'

debug = require('debug') 'smartLeave:index'




multer = require 'multer'


fs= require 'fs'





localStrategy = new LocalStrategy({usernameField: 'username',passwordField: 'pwd'},(username,password,done)->
		
		LSys = LeaveSystemSingleton.get()

		user = LSys.getPeopleByName(username)
		debug user
		if user is null 
			return done null,false,{message: 'Invalid user'}
		if user.pwd isnt password
			return done null,false,{message: 'Invalid password'}

		done null,user

	)


Passport.use( 'local', localStrategy );


router.use Passport.initialize()





# GET home page.
router.get '/login', (req, res, next) ->
	
	LSys = LeaveSystemSingleton.get()
	LSys.showArchitecture()


	res.render "login",
	style:"./stylesheets/login.css"
	script:"./javascripts/login.js"



module.exports = router


router.post '/login',Passport.authenticate( 'local', {session:false,failureFlash: false} ),(req,res)->

	debug req.user.name,req.user["_id"]
	sessionManager.setSession(req.user.name,req.user["_id"])
	res.cookie "ID", req.user["_id"]

	res.redirect("../mainPage")


router.get '/newStaff', (req, res, next) ->

	res.render "newStaff",
	style:"./stylesheets/login.css"




imgMarkPath='./public/dataPool/mark/'
destinationFn=(req,file,cb)->
	cb(null,imgMarkPath)



storage = multer.diskStorage({destination:destinationFn})



uploadMark = multer({storage:storage})


router.post '/newStaff',uploadMark.single("mark"),(req,res)->
	LSys = LeaveSystemSingleton.get()
	

	#should merge into people module
	levelTlb={"大隊長":1,"副大隊長":2,"分隊長":3,"小隊長":4,"隊員":5}


	debug req.file

	newPeople = new People({name: req.body.name,
	boss: req.body.boss,
	level: levelTlb[req.body.title],
	title: req.body.title,
	startCareerDate: req.body.startCareerDate,
	availableDay: req.body.availableDay,
	useDay: 0,
	pwd: req.body.pwd,
	waitHQueue:{}


							 })

	debug newPeople['_id']
	uploadFileName= req.file['filename']

	fs.rename(""+imgMarkPath+uploadFileName,""+imgMarkPath+newPeople['_id']+".png")


	LSys.addPeople(newPeople)



	newPeople.save((err)->

		if err
			debug err

		)
	res.send "新增完成"