

db = require './db'
debug = require('debug') 'smartLeave:ctl'

Readline  = require "readline"

People =require "./People"



rl=Readline.createInterface({
 	input: process.stdin,
 	output: process.stdout,
 	terminal: false
})




#  1.修改密碼 2.詢問密碼 3.刪除資料 


rl.question "請輸入人名: ",(name)->

	People.find {name:name},(err,pList)->
		if err
			debug err
			return 
		
		pNode=pList[0]

		console.log "姓名: "+pNode["name"]
		console.log "分隊: "+pNode["team"]
		console.log "密碼: "+pNode["pwd"]


		rl.question "請輸入: 1.修改密碼 2.刪除資料: ", (opt)->

			debug opt

			if opt =='1'

				rl.question "輸入新密碼: ", (pwd)->

					People.update {name:name}, {pwd:pwd},(err,raw)->
						if err
							debug err
						else
							console.log "修改完成!!"
							rl.close()
							db.close()


			if opt =='2'
					People.remove {name:name},(err,raw)->

						if err
							debug err
						else
							console.log "已移除!!"
							rl.close()
							db.close()


		


	



rl.on('line', (line)->
    console.log(line))

#People.find()