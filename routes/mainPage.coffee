express = require 'express'
fs = require 'fs'

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

	
	LSys.showArchitecture()
	formList=LSys.getPersonFormListByName("許木坤")
	res.render 'mainPage',
	style: "./stylesheets/mainPage.css",
	historyList: formList

	

#upload
router.post '/uploadForm',(req,res)->

	
	name=req.body.name.replace " ",""
	dt=genDate()
	urlToImage './dataPool/forms/'+dt+"-"+name+'.png',req.body.image

	#create data object LeaveForm("許木坤","20170101","楊文宏")
	newForm=new LeaveForm(name,genDate(),req.body.deputyName)
	
	console.log newForm
	LSys.addNewForm(newForm)


	 


router.get '/editForm', (req, res, next) ->
  res.render 'editForm',
    script: '../javascripts/ImageUtility.js'
    form: "../images/form.png"
    style: "../stylesheets/editForm.css"
    name:"許木坤"
    role:"individual"
    FID:"123"
    markID: 1
    startCareerDay:"2017/01/01"
    availableDay:200
    useDay:199

    





module.exports = router


#============================

urlToImage = (path,url) ->

	data=url.replace /^data:image\/\w+;base64,/, ""

	#console.log url
	buf = new Buffer data, 'base64'
	fs.writeFile path,buf
	return 



genDate =()->
	dt = new Date()
	year=dt.getFullYear()
	month=dt.getMonth()+1
	day=dt.getDate()
	h=dt.getHours()
	m=dt.getMonth() 
	sec=dt.getSeconds() 

	return year+""+month+""+day+""+h+""+m+""+sec
