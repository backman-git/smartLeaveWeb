
debug = require('debug') 'smartLeave:test'





db = require './db'
People =require "./People"

#should merge into people module
#levelTlb={"大隊長":1,"副大隊長":2,"分隊長":3,"小隊長":4,"隊員":5}


p1= new People({name:"假單庫",boss:"",level:0,title:"",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})
p2= new People({name:"人事室",boss:"假單庫",level:0,title:"",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})





p3= new People({name:"林子博",boss:"高仲毅",level:3,title:"分隊長",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})
p4= new People({name:"林訓",boss:"林子博",level:4,title:"隊員",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})
p5= new People({name:"許木坤",boss:"林子博",level:5,title:"隊員",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})
p6= new People({name:"林茂昌",boss:"林子博",level:5,title:"隊員",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})






p7= new People({name:"高仲毅",boss:"人事室",level:1,title:"大隊長",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})
p8= new People({name:"張哲彬",boss:"高仲毅",level:2,title:"副大隊長",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})
p9= new People({name:"黃國勛",boss:"高仲毅",level:5,title:"小隊長",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})
p10= new People({name:"王詩強",boss:"高仲毅",level:5,title:"隊員",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})
p11= new People({name:"高碧霙",boss:"高仲毅",level:5,title:"隊員",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})



p1.save()
p2.save()

p3.save()
p4.save()
p5.save()
p6.save()
p7.save()
p8.save()
p9.save()
p10.save()
p11.save()










db = require '../coffee/db'



LeaveSystemSingleton = require '../coffee/LeaveSystemSingleton'
People = require '../coffee/People'

LeaveForm = require '../coffee/LeaveForm'


testFunction= (LSys)->

	'''
	
	#type 1  隊員 short
	form1 = new LeaveForm("許木坤","2017/01/01","林茂昌","short")

	LSys.addNewForm(form1)

	LSys.submitFormByID("許木坤",form1.fileID)

	LSys.submitFormByID("林茂昌",form1.fileID)

	LSys.submitFormByID("林子博",form1.fileID)

	LSys.submitFormByID("高仲毅",form1.fileID)

	debug "type 1:"+form1.isFinish()
	


	
	#type 2  小隊長 short
	form2 = new LeaveForm("林訓","2017/01/01","許木坤","short")

	LSys.addNewForm(form2)

	LSys.submitFormByID("林訓",form2.fileID)

	LSys.submitFormByID("許木坤",form2.fileID)

	LSys.submitFormByID("林子博",form2.fileID)

	LSys.submitFormByID("高仲毅",form2.fileID)

	debug "type 2:"+form2.isFinish()


	
	#type 3 副大隊長
	form3 = new LeaveForm("張哲彬","2017/01/01","黃國勛","short")

	LSys.addNewForm(form3)

	LSys.submitFormByID("張哲彬",form3.fileID)

	LSys.submitFormByID("黃國勛",form3.fileID)

	LSys.submitFormByID("高仲毅",form3.fileID)

	LSys.submitFormByID("高仲毅",form3.fileID)

	debug "type 3:"+form3.isFinish()


	#type 4 大隊長

	form4 = new LeaveForm("高仲毅","2017/01/01","張哲彬","short")

	LSys.addNewForm(form4)

	LSys.submitFormByID("高仲毅",form4.fileID)

	LSys.submitFormByID("張哲彬",form4.fileID)

	LSys.submitFormByID("高仲毅",form4.fileID)

	LSys.submitFormByID("高仲毅",form4.fileID)

	debug "type 4:"+form4.isFinish()




	#type 5 大隊 隊員


	form5 = new LeaveForm("高碧霙","2017/01/01","王詩強","short")

	LSys.addNewForm(form5)

	LSys.submitFormByID("高碧霙",form5.fileID)

	LSys.submitFormByID("王詩強",form5.fileID)

	LSys.submitFormByID("高仲毅",form5.fileID)

	LSys.submitFormByID("高仲毅",form5.fileID)

	debug "type 5:"+form5.isFinish()


	#type 6 大隊 小隊長

	form6 = new LeaveForm("黃國勛","2017/01/01","高碧霙","short")

	LSys.addNewForm(form6)

	LSys.submitFormByID("黃國勛",form6.fileID)

	LSys.submitFormByID("高碧霙",form6.fileID)

	LSys.submitFormByID("高仲毅",form6.fileID)

	LSys.submitFormByID("高仲毅",form6.fileID)

	debug "type 6:"+form6.isFinish()



	#type 7 分隊長

	form7 = new LeaveForm("林子博","2017/01/01","林訓","short")

	LSys.addNewForm(form7)

	LSys.submitFormByID("林子博",form7.fileID)

	LSys.submitFormByID("林訓",form7.fileID)

	LSys.submitFormByID("林子博",form7.fileID)

	LSys.submitFormByID("高仲毅",form7.fileID)

	debug "type 7:"+form7.isFinish()

	
	'''
	#type 8 分隊隊員 long
	
	form8 = new LeaveForm("許木坤","2017/01/01","林茂昌","long")

	LSys.addNewForm(form8)

	LSys.submitFormByID("許木坤",form8.fileID)

	LSys.submitFormByID("林茂昌",form8.fileID)

	LSys.submitFormByID("林子博",form8.fileID)

	LSys.submitFormByID("高仲毅",form8.fileID)

	LSys.submitFormByID("人事室",form8.fileID)

	debug "type 8:"+form8.isFinish()
	


	#type 9 分隊小隊長 long
	
	form9 = new LeaveForm("林訓","2017/01/01","林茂昌","long")

	LSys.addNewForm(form9)

	LSys.submitFormByID("林訓",form9.fileID)

	LSys.submitFormByID("林茂昌",form9.fileID)

	LSys.submitFormByID("林子博",form9.fileID)

	LSys.submitFormByID("高仲毅",form9.fileID)

	LSys.submitFormByID("人事室",form9.fileID)

	debug "type 9:"+form9.isFinish()




	#type 10 分隊分隊長 long
	
	form10 = new LeaveForm("林子博","2017/01/01","林訓","long")

	LSys.addNewForm(form10)

	LSys.submitFormByID("林子博",form10.fileID)

	LSys.submitFormByID("林訓",form10.fileID)

	LSys.submitFormByID("林子博",form10.fileID)

	LSys.submitFormByID("高仲毅",form10.fileID)

	LSys.submitFormByID("人事室",form10.fileID)

	debug "type 10:"+form10.isFinish()


	#type 11 大隊隊員 long
	
	form11 = new LeaveForm("高碧霙","2017/01/01","王詩強","long")

	LSys.addNewForm(form11)

	LSys.submitFormByID("高碧霙",form11.fileID)

	LSys.submitFormByID("王詩強",form11.fileID)

	LSys.submitFormByID("高仲毅",form11.fileID)

	LSys.submitFormByID("高仲毅",form11.fileID)

	LSys.submitFormByID("人事室",form11.fileID)

	debug "type 11:"+form11.isFinish()


	#type 12 大隊小隊長 long
	
	form12 = new LeaveForm("黃國勛","2017/01/01","王詩強","long")

	LSys.addNewForm(form12)

	LSys.submitFormByID("黃國勛",form12.fileID)

	LSys.submitFormByID("王詩強",form12.fileID)

	LSys.submitFormByID("高仲毅",form12.fileID)

	LSys.submitFormByID("高仲毅",form12.fileID)

	LSys.submitFormByID("人事室",form12.fileID)

	debug "type 12:"+form12.isFinish()


	#type 13 大隊副隊長 long
	
	form13 = new LeaveForm("張哲彬","2017/01/01","黃國勛","long")

	LSys.addNewForm(form13)

	LSys.submitFormByID("張哲彬",form13.fileID)

	LSys.submitFormByID("黃國勛",form13.fileID)

	LSys.submitFormByID("高仲毅",form13.fileID)

	LSys.submitFormByID("高仲毅",form13.fileID)

	LSys.submitFormByID("人事室",form13.fileID)

	debug "type 13:"+form13.isFinish()

	#type 14 大隊大隊長 long
	
	form14 = new LeaveForm("高仲毅","2017/01/01","張哲彬","long")

	LSys.addNewForm(form14)

	LSys.submitFormByID("高仲毅",form14.fileID)

	LSys.submitFormByID("張哲彬",form14.fileID)

	LSys.submitFormByID("高仲毅",form14.fileID)

	LSys.submitFormByID("高仲毅",form14.fileID)

	LSys.submitFormByID("人事室",form14.fileID)

	debug "type 14:"+form14.isFinish()
	
	

	

	
	
	
	
	
	
	






db.on('error', console.error.bind(console, 'connection error:'))

db.once('open',()->
	console.log "Leave System connected to database."


	People.find({},(err,pList)->
		
		LeaveSystemSingleton.buildTree(pList)
		LeaveSystemSingleton.setReady(true)
		LSys = LeaveSystemSingleton.get()
		testFunction(LSys)

		
	

	) 



)


