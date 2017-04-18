Node =require "./Node"
People =require "./People"
LeaveForm = require "./LeaveForm"






class LeaveSystem

	constructor:(@mainTreeRoot)->
		@formsList={}
		#build hashTable of nodes
		@treeHT=genHT_of_Tree(@mainTreeRoot)


	getSecurityLevelByName:(name)->
		return @treeHT[name].value.level

	getPeopleNodeByName:(name)->
		return clone @treeHT[name].value


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

		if this.getSecurityLevelByName(name) ==0
			role="personnel"

		else if this.getNameByFID(FID) == name
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
		#final queue
		@treeHT["假單庫"].value.addFormToWaitHQueue(form)		





	submitFormByID:(name,FID)->



		role=this.getRole(name,FID)
		p=@treeHT[name].value
		form=p.retriveFormByFID(FID)
		form.setState(role,true)


		if role is "personnel"
			p.addFormToWaitHQueue(form)

		else if role is "boss" 
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





top= new Node( new People("假單庫",0,"假單庫","2017/6/6",0),null)
a1= new Node( new People("劉采鑫",1,"大隊長","2017/1/1",0),top)
a2= new Node( new People("沈俊興",1,"大隊長","2017/1/1",0),top)
a3= new Node( new People("陳岳謄",1,"大隊長","2017/1/1",0),top)

b1= new Node( new People("林子博",2,"分隊長","2017/1/1",0),a1)
b2= new Node( new People("陳勝佑",2,"分隊長","2017/1/1",0),a2)
b3= new Node( new People("何建樺",2,"分隊長","2017/1/1",0),a3)


c1= new Node( new People("許木坤",3,"隊員","2017/1/1",200),b1)
c2= new Node( new People("楊文宏",3,"隊員","2017/1/1",0),b1)
c3= new Node( new People("王邦晟",3,"隊員","2017/1/1",0),b3)






class LeaveSystemSingleton

	instance=null
	top=null
	@build:()->

		top= new Node( new People("假單庫",0,"假單庫","2017/6/6",0),null)
		a1= new Node( new People("劉采鑫",1,"大隊長","2017/1/1",0),top)
		a2= new Node( new People("沈俊興",1,"大隊長","2017/1/1",0),top)
		a3= new Node( new People("陳岳謄",1,"大隊長","2017/1/1",0),top)
		b1= new Node( new People("林子博",2,"分隊長","2017/1/1",0),a1)
		b2= new Node( new People("陳勝佑",2,"分隊長","2017/1/1",0),a2)
		b3= new Node( new People("何建樺",2,"分隊長","2017/1/1",0),a3)
		c1= new Node( new People("許木坤",3,"隊員","2017/1/1",200),b1)
		c2= new Node( new People("楊文宏",3,"隊員","2017/1/1",0),b1)
		c3= new Node( new People("王邦晟",3,"隊員","2017/1/1",0),b3)
		return top

	@get:()->
		top=@build()

		if  instance != null
			return instance
		else
			instance = new LeaveSystem(top)
			return instance














module.exports =LeaveSystemSingleton