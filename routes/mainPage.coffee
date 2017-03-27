express = require 'express'
router = express.Router()


#-----------main componment--------------------------

Node =require "../coffee/Node"
People =require "../coffee/People"
LeaveForm = require "../coffee/LeaveForm"
LeaveSystem = require "../coffee/LeaveSystem"

# template tree



top= new Node( new People("假單庫",0,"假單庫"),null)
a1= new Node( new People("劉采鑫",1,"大隊長"),top)
a2= new Node( new People("沈俊興",1,"大隊長"),top)
a3= new Node( new People("陳岳謄",1,"大隊長"),top)

b1= new Node( new People("林子博",2,"分隊長"),a1)
b2= new Node( new People("陳勝佑",2,"分隊長"),a2)
b3= new Node( new People("何建樺",2,"分隊長"),a3)


c1= new Node( new People("許木坤",3,"隊員"),b1)
c2= new Node( new People("楊文宏",3,"隊員"),b1)
c3= new Node( new People("王邦晟",3,"隊員"),b3)




LSys = new LeaveSystem(top) 


#----------------------------------------------------


router.get '/', (req, res, next) ->

	a=new LeaveForm("許木坤","20170101","楊文宏")
	b=new LeaveForm("許木坤","20170102","楊文宏")
	LSys.addNewForm(a)
	LSys.addNewForm(b)
	#LSys.showArchitecture()
	formList=LSys.getPersonFormListByName("許木坤")



	res.render 'mainPage',
	style: "./stylesheets/mainPage.css",
	historyList: formList








module.exports = router
