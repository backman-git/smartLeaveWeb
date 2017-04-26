
debug = require('debug') 'smartLeave:SessionManager'

class SessionManager

	@sessionList={}


	@setSession:(name,id)->

		@sessionList[id]=name
		debug @sessionList
		return 

	@getSessionName:(id)->
		debug @sessionList
		return @sessionList[id]

	@getSessionID:(name)->

		for k,v of @sessionList
			
			if v == name
				return k

		return null




module.exports= SessionManager