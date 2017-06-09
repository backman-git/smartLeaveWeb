








debug = require('debug') 'smartLeave:SecurityManager'


#plugin 
class SecurityManager

	@sessionList={}

	@maintagID=0

	@maxIDN=5000

	@getTagID:()->

		if @maintagID >=@maxIDN
			@maintagID=0

		return ""+((@maintagID+=1)%@maxIDN)

	@queryAccount:(tagID)->

		debug @sessionList

		if tagID of @sessionList
			return @sessionList[tagID]
		else
			return {status:false}

	
	@sendCertification:(phoneID,tagID)->

		#test

		tlb={"0933216219":{status:true,name:"救災救護指揮中心-鄭建國",pwd:"5325707","uid":"592242df157ab22db8422671"},"0900112233":{status:true,name:"公園分隊-林茂昌",pwd:"5325707","uid":"592242e0157ab22db84226a9"}}

		@sessionList[""+tagID]=tlb[""+phoneID]
		return 




module.exports =SecurityManager