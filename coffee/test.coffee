'''

Node =require "./Node"
People =require "./People"
LeaveForm = require "./LeaveForm"
LeaveSystem = require "./LeaveSystem"





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










'''


lss=require "./LeaveSystemSingleton"

system = lss.get()




a=new LeaveForm("許木坤","20170101","楊文宏")
b=new LeaveForm("許木坤","20170102","楊文宏")


system.addNewForm(a)
system.addNewForm(b)

#system.submitFormByID("許木坤","20170101-許木坤")


system.showArchitecture()

a=system.getPersonFormListByName("許木坤")