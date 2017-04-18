express = require 'express'
router = express.Router()

#------passport--
Passport = require('passport')
LocalStrategy = require('passport-local').Strategy  
session = require('express-session')  
#RedisStore = require('connect-redis')(session)


# only for test should use in dataBase
users = {'人事室': {username: '假單庫',password: '123',id:'0'}, '許木坤': {username: '許木坤',password: '1',id: '101'},'林子博': {username: '林子博',password: '5',id: '202'},'楊文宏': {username: '楊文宏',password: '2',id: '303'}}
idTable={'101':"許木坤",'202':"林子博",'303':"楊文宏",'0':"假單庫"}


localStrategy = new LocalStrategy({usernameField: 'username',passwordField: 'pwd'},(username,password,done)->
		user =users[username]
		if user is null 
			return done null,false,{message: 'Invalid user'}
		if user.password isnt password
			return done null,false,{message: 'Invalid password'}

		done null,user

	)


Passport.use( 'local', localStrategy );


router.use Passport.initialize()





# GET home page.
router.get '/login', (req, res, next) ->
	

	res.render "login"


module.exports = router


router.post '/login',Passport.authenticate( 'local', {session:false} ),(req,res)->

	res.cookie "ID", req.user.id
	res.redirect("../mainPage")