
db = require './db'
People =require "./People"


p1= new People({name:"假單庫",boss:"",level:0,title:"",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})
p2= new People({name:"人事室",boss:"",level:0,title:"",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})

p1.save()
p2.save(()->
	db.close()
	)



