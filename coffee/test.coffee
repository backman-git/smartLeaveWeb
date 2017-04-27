
db = require './db'
People =require "./People"



p1= new People({name:"假單庫",boss:"",level:0,title:"",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})
p2= new People({name:"人事室",boss:"假單庫",level:0,title:"",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})

p1.save()
p2.save(()->
	db.close()
	)




'''

leaveForm = require './leaveForm'


#@name,@date,deputy,@type
f1 = new leaveForm('k','2017/0101','g','long')


#@state={"individual":false,"deputy":false,"firstBoss":false,"secondBoss":false,"personnel":false}
f1.setState('individual',true)
f1.setState('deputy',true)
f1.setState('firstBoss',true)
f1.setState('secondBoss',false)
f1.setState('personnel',true)


console.log f1.isFinish()
'''