



class LeaveSystem

	constructor:(@mainTreeRoot)->
		@formsList={}

		#build hashTable of nodes
		@treeHT=genHT_of_Tree(@mainTreeRoot)


	getSecurityLevelByName:(name)->
		return @treeHT[name].value.level

	getSecurityLevelByFID:(FID)->
		name=this.getNameByFID(FID)

		return @treeHT[name].value.level

	getNameByFID:(FID)->
		FID=FID.split("-",2)
		return FID[1]



	showArchitecture:()->
		console.log "------------------------------------------\n"
		queue=[]

		if @mainTreeRoot is null
			console.log "Null"


		else
			queue.push(@mainTreeRoot)
			currentLevel=@mainTreeRoot.value.level


			while queue.length !=0
				a=queue.shift()


				if currentLevel < a.value.level
					currentLevel=a.value.level
					console.log "\n"

			
				process.stdout.write(a.value.name+": ")

				for k,v of a.value.getWaitHQueue()
					process.stdout.write("("+k+","+v+") ")


				for c in a.getChild()
					queue.push(c)

		console.log "\n\n------------------------------------------\n"






	addFormToFormsList:(form)->

		if form.name of @formsList
			@formsList[form.name][form.fileID]=form
		else
			@formsList[form.name]={}
			@formsList[form.name][form.fileID]=form


	addNewForm:(form)->
		@treeHT[form.name].value.addFormToWaitHQueue(form)
		this.addFormToFormsList(form)


	

	getFormsList:()->
		return clone(@formsList)




	getRole:(name,FID)->
		role=""

		if this.getNameByFID(FID) == name
			role="individual"		

		else if this.getSecurityLevelByName(name) == this.getSecurityLevelByFID(FID)

			role="deputy"
		else if this.getSecurityLevelByName(name) < this.getSecurityLevelByFID(FID)
			role="boss"
		else
			role="Error"
		return role


	checkFormFinish:(form)->
		for k,v of form.getState()
			if v == false
				return false
		return true



	pushToFQ:(form)->

		@treeHT["假單庫"].value.addFormToWaitHQueue(form)		


		console.log form.name+" is Finish."

	submitFormById:(name,FID)->

		role=this.getRole(name,FID)


		p=@treeHT[name].value
		form=p.retriveFormByFID(FID)
		form.setState(role,true)
			

		if this.checkFormFinish(form) == true
			this.pushToFQ(form)

		else if role is "deputy"
			pParent=@treeHT[name].getParent().value

			pParent.addFormToWaitHQueue(form)

		else if role is "individual"
			deputy =@treeHT[form.getRoleName("deputy") ]
			deputy=deputy.value
			deputy.addFormToWaitHQueue(form)

	getPersonFormListByName:(name)->
		return clone @formsList[name]
	

	getFormByFID:(id)->
		name=this.getNameByFID(id)
		fList=this.getPersonFormListByName(name)

		return clone fList[id]


	




genHT_of_Tree = (root)->

	HT={}
	queue=[]

	if root is null
		console.log "Null"


	else
		queue.push(root)
		currentLevel=root.value.level


		while queue.length !=0
			a=queue.shift()


			HT[a.value.name]=a

			for c in a.getChild()
				queue.push(c)

	return HT


clone = (obj) ->
  if not obj? or typeof obj isnt 'object'
    return obj

  if obj instanceof Date
    return new Date(obj.getTime()) 

  if obj instanceof RegExp
    flags = ''
    flags += 'g' if obj.global?
    flags += 'i' if obj.ignoreCase?
    flags += 'm' if obj.multiline?
    flags += 'y' if obj.sticky?
    return new RegExp(obj.source, flags) 

  newInstance = new obj.constructor()

  for key of obj
    newInstance[key] = clone obj[key]

  return newInstance

module.exports =LeaveSystem