

class LeaveForm

	constructor:(@name,@date,deputy)->
		@fileID=@date+"-"+@name
		@imagePath=""


		@state={"individual":false,"deputy":false,"boss":false,"personnel":false}

		@roles={"individual":"","deputy":"","boss":""}
		this.setRoleName("deputy",deputy)
		this.setRoleName("individual",@name)

	#BX
	setImageDir:(path)->
		@imagePath="public/"+path+'/'+@fileID+".png"
		@imageUri = "../"+path+'/'+@fileID+".png"
	getImagePath:()->
		return @imagePath

	getImageUri:()->
		return @imageUri




	getOwner:()->
		return @name


	setRoleName:(role,name)->
		@roles[role]=name


	setState:(stateID,value) ->
		@state[stateID]=value

	getState:()->
		return @state

	getRoleName:(role)->
		return @roles[role]

	getFID:()->
		return @fileID



module.exports = LeaveForm