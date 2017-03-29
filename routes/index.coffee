express = require 'express'
router = express.Router()

#------passport--
Passport = require('passport')
LocalStrategy = require('passport-local').Strategy  
session = require('express-session')  
#RedisStore = require('connect-redis')(session)



users = {zack: {username: 'zack',password: '1234',id: 1},node: {username: 'node',password: '5678',id: 2},}


localStrategy = new LocalStrategy({usernameField: 'username',passwordField: 'password'},(username,password,done)->
		user =user[username]
		if user is null 
			return done null,false,{message: 'Invalid user'}
		if user.password isnt password
			return done null,false,{message: 'Invalid password'}

		done null,user

	)


Passport.use( 'local', localStrategy );



router.use Passport.initialize()





# GET home page.
router.get '/', (req, res, next) ->
	

	res.render "login"


module.exports = router


router.post '/', Passport.authenticate('local',{session:false}),(req,res)->
	res.send "user ID"+req.user.id