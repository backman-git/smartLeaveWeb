db = require './db'
People =require "./People"

#should merge into people module
#levelTlb={"大隊長":1,"副大隊長":2,"分隊長":3,"小隊長":4,"隊員":5}


p1= new People({name:"假單庫",team:"SYSTEM",boss:"",level:0,title:"",startCareerDate:"2017.01.01",availableDay:0,useDay:0,pwd:"1"})
p2= new People({name:"人事室",team:"SYSTEM",boss:"假單庫",level:0,title:"ADMIN",startCareerDate:"2017.01.01",availableDay:0,useDay:0,pwd:"1"})

p1.save()
p2.save(()->
	db.close())