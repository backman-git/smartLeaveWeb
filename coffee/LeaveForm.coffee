

class LeaveForm

	constructor:(@name,@date,deputy)->
		@fileID=@date+"-"+@name
		@state={"individual":false,"deputy":false,"boss":false}

		@roles={"individual":"","deputy":"","boss":""}
		this.setRoleName("deputy",deputy)


	setRoleName:(role,name)->
		@roles[role]=name


	setState:(stateID,value) ->
		@state[stateID]=value

	getState:()->
		return @state

	getRoleName:(role)->
		return @roles[role]



module.exports = LeaveForm