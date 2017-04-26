class Node

	constructor:(@value)->
		@childList=[]

		

			
	setChild:(child)->
		@childList.push(child)

	getChild:()->
		return @childList

	setParent:(@parent)->

		if @parent != null
			@parent.setChild(this)
			

	getParent:()->
		return @parent


module.exports= Node