

class People
	
	constructor:(@name,@level,@title)->

		@waitHQueue={}

	addFormToWaitHQueue:(form)->
		@waitHQueue[form.fileID]=form

	getWaitHQueue:()->
		return @waitHQueue

	retriveFormByFID:(FID)->
		form= @waitHQueue[FID]

		delete @waitHQueue[FID]

		


		return form
	

module.exports= People