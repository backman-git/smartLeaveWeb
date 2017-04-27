Node =require "./Node"
People =require "./People"
LeaveForm = require "./LeaveForm"


debug = require('debug') 'smartLeave:LSys'


class LeaveSystem

	constructor:(@mainTreeRoot)->
		@formsList={}
		#build hashTable of nodes
		@treeHT=genHT_of_Tree(@mainTreeRoot)


	addPeople:(p)->

		@treeHT[p.name]= new Node p

		return 

	getPeopleByName:(name)->

		if name of @treeHT
			t = @treeHT[name]
			return t.value
		else
			return null

	getSecurityLevelByName:(name)->
		return @treeHT[name].value.level

	getPeopleNodeByName:(name)->
		return  @treeHT[name].value


	getSecurityLevelByFID:(FID)->
		name=this.getNameByFID(FID)

		return @treeHT[name].value.level

	getNameByFID:(FID)->
		FID=FID.split("-",2)
		return FID[1]



	showArchitecture:()->
		debug "------------------------------------------\n"
		queue=[]

		if @mainTreeRoot is null
			debug "Null"


		else
			queue.push(@mainTreeRoot)
			currentLevel=@mainTreeRoot.value.level


			while queue.length !=0
				a=queue.shift()


				if currentLevel < a.value.level
					currentLevel=a.value.level
					debug "\n"

			
				process.stdout.write(a.value.name+": ")

				for k,v of a.value.getWaitHQueue()
					process.stdout.write("("+k+","+v+") ")


				for c in a.getChild()
					queue.push(c)

		debug "\n\n------------------------------------------\n"






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

		if this.getSecurityLevelByName(name) ==0
			role="personnel"

		else if this.getNameByFID(FID) == name
			role="individual"		

		else if this.getSecurityLevelByName(name) == this.getSecurityLevelByFID(FID)
			role="deputy"
		else if this.getSecurityLevelByName(name)+1 == this.getSecurityLevelByFID(FID)
			role="firstBoss"
		else if this.getSecurityLevelByName(name)+2 == this.getSecurityLevelByFID(FID)
			role="secondBoss"
		else
			role="Error"
		return role


	checkFormFinish:(form)->
		for k,v of form.getState()
			if v == false
				return false
		return true



	pushToReviewQ:(form)->
		#final queue
		@treeHT["假單庫"].value.addFormToWaitHQueue(form)		





	submitFormByID:(name,FID)->



		role=this.getRole(name,FID)
		p=@treeHT[name].value
		form=p.retriveFormByFID(FID)
		form.setState(role,true)


		if role is "personnel"
			p.addFormToWaitHQueue(form)
			
			#just for backup!!
			this.pushToReviewQ(form)

		else if role is "firstBoss" 
			pParent=@treeHT[name].getParent().value
			pParent.addFormToWaitHQueue(form)

		else if role is "secondBoss" and form.getType() =="short"
			p.addFormToWaitHQueue(form)

			#just for backup!!
			this.pushToReviewQ(form)

		else if role is "secondBoss" and form.getType() =="long"
			pParent=@treeHT[name].getParent().value
			pParent.addFormToWaitHQueue(form)

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
		debug "Null"


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



emptyFunction =()->
	return





class LeaveSystemSingleton

	@instance=null

	@treeNodes={}
	@readFlag=false


	
	@get:()->
		

		if @readFlag == false
			return null


		else if  @instance != null 
			return @instance
		
		
		else
			debug "LSys is ready to go"
			@instance = new LeaveSystem(@treeNodes['假單庫'])
			return @instance




	@buildTree:(pList)->

		for p in pList
				@treeNodes[p.name]=new Node p


		for key,n of @treeNodes
			if n.value.boss !=""
				n.setParent(@treeNodes[n.value.boss])
		return @treeNodes
	


	@setReady:(f)->
		@readFlag=f
		return











module.exports =LeaveSystemSingleton