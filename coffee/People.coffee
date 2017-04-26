



mongoose = require('mongoose')






PeopleSchema = mongoose.Schema({

	name: String,
	boss: String,
	level: Number,
	title: String,
	startCareerDate: String,
	availableDay: Number,
	useDay: Number,
	pwd: String,
	waitHQueue: { type: mongoose.Schema.Types.Mixed, default: {} }},
	{ minimize: false }




	)


PeopleSchema.methods.addFormToWaitHQueue=(form)->
	@waitHQueue[form.fileID]=form

PeopleSchema.methods.getWaitHQueue=()->
	return @waitHQueue


PeopleSchema.methods.retriveFormByFID=(FID)->
	form= @waitHQueue[FID]

	delete @waitHQueue[FID]

	return form
PeopleSchema.methods.setUseDay=(n)->
	@useDay=n
	return

PeopleSchema.methods.getUseDay=(n)->

	out=@useDay

	return out




People=mongoose.model 'people', PeopleSchema









'''
p1= new People({name:"假單庫",boss:"",level:0,title:"",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})
p2= new People({name:"林子博",boss:"假單庫",level:1,title:"分隊長",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})
p3= new People({name:"許木坤",boss:"林子博",level:2,title:"隊員",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})
p4= new People({name:"楊易山",boss:"林子博",level:2,title:"隊員",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})
p5= new People({name:"林茂昌",boss:"林子博",level:2,title:"隊員",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})
p6= new People({name:"涂邑憲",boss:"林子博",level:2,title:"隊員",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})
p1.save()
p2.save()
p3.save()
p4.save()
p5.save()
p6.save()
'''

module.exports= People