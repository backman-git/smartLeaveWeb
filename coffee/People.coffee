

class People
	
	constructor:(@name,@level,@title,@startCareerDate,@availableDay)->

		@waitHQueue={}
		@useDay=0

	addFormToWaitHQueue:(form)->
		@waitHQueue[form.fileID]=form

	getWaitHQueue:()->
		return @waitHQueue

	retriveFormByFID:(FID)->
		form= @waitHQueue[FID]

		delete @waitHQueue[FID]

		return form


	setUseDay:(n)->
		@useDay=n
		return


	getUseDay:(n)->

		out=@useDay

		return out


		
	

module.exports= People