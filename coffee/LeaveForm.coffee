

class LeaveForm

	constructor:(@name,@date,deputy,@type)->
		#so important!!!!!
		@fileID=@date+"^"+@name
		@imagePath=""
		

		@finish=false
		@state={"individual":false,"deputy":false,"firstBoss":false,"secondBoss":false,"personnel":false,"cancel":false}

		@roles={"individual":"","deputy":"","boss":"","canceler":""}
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

	isFinish:()->
		if @type=="short" and @state['individual'] and @state['deputy'] and @state['firstBoss'] and @state['secondBoss']
			return true


		else if @type=="long" and @state['individual'] and @state['deputy'] and @state['firstBoss']  and @state['secondBoss'] and @state['personnel']
			return true
		else
			return false



	isCancel:()->
		return @state["cancel"]

	cancelByName:(name)->
		this.setRoleName("canceler",name)
		this.setState("cancel",true)

	getType:()->
		return @type


	getOwner:()->
		return @name


	setRoleName:(role,name)->
		@roles[role]=name


	setState:(stateID,value) ->
		@state[stateID]=value
		@finish=this.isFinish()



	getState:()->
		return @state

	getRoleName:(role)->
		return @roles[role]

	getFID:()->
		return @fileID



module.exports = LeaveForm