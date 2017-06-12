

#put in order server??



define(()->


	class securityQR

		constructor:()->
			@pID=0
			@tagID=-10
			image=document.getElementById('SQR') 
			downloadingImage = new Image()
			downloadingImage.onload= ()-> image.src=this.src

			

			$.get "/security/QRTag",(data,status)=>

					console.log data
					QRImgPath=data["QRImgPath"]
					downloadingImage.src="../QR/"+QRImgPath
					#downloadingImage.src="/dataPool/mark/592242de157ab22db8422653.png"
					@tagID=data["tagID"]

					return
			


			

			return 
		

		on:(fn)->
			@trigerFn=fn

		setData:(data)->
			@trigerFn(data)




		getInfo:()->

			$.get "/security/getAccount",{ tagID: ""+@tagID},(data,status)=>
				console.log data
				#final data

				if data["status"] != false
					clearInterval(@pID)
					this.setData(data)
					


		implantQR:()->


			#polling for information
			#so important!
			
			
			@pID=setInterval((()=> 
				


				



				this.getInfo()),100)
				
			
			
			

				

			

			return 



)










#=================================











