class Node

	constructor:(@value,@parent)->
		@childList=[]

		if @parent != null
			@parent.setChild(this)
			

			
	setChild:(child)->
		@childList.push(child)

	getChild:()->
		return @childList

	setParent:(newParent)->
		#bug not remove child
		@parent=newParent
		#newParent.setChild(this)

	getParent:()->
		return @parent


module.exports= Node