





$(document).ready ->

	$("#Form").hide()






	ImageFactory =(ctx)->
		this.ctx=ctx
		this.drawImage = (image_arg,image_x,image_y)->
			_this= this
			image = new Image()
			image.onload = () ->
				_this.ctx.drawImage(image,image_x,image_y)
				return 
			image.src=image_arg	
			return
		return


	





	showMark = (event ) ->
		$(this).text("")
		
		str1="url("
		str2=")"
		str3=str1.concat event.data.p1
		str3=str3.concat str2
		$(this).css("background-image",str3  )
		$(this).css("background-image",str3  )
		$(this).css("height","50px"  )
		$(this).css("width","120px"  )
		$(this).css("left","350px"  )
		return


	printTextToForm=(ID)->
		ctx = $("#Canvas")[0].getContext('2d')
		#name

		ctx.font = "45px Arial"
		x=parseInt ( $("#"+ID).css("left") )
	
		
		y=parseInt( $("#"+ID).css("top") )
		#bias
		y+=40

		ctx.fillText($("#"+ID).text(), x , y )
		
		return

	printDayToForm=(ID)->
		ctx = $("#Canvas")[0].getContext('2d')

		ctx.font = "20px Arial"
		p=$("#"+ID).offset()		
		#bias
		ctx.fillText($("#"+ID).val(), p.left-40 , p.top )
		
		return


	printImgtoForm=(ID)->
		ctx = $("#Canvas")[0].getContext('2d')
		imageFactory =new ImageFactory ctx
		bgImg=$("#"+ID).css("background-image")
		bgImg=bgImg.replace('url(','').replace(')','').replace(/\"/gi, "")
		imageFactory.drawImage( bgImg , parseInt($("#"+ID).css("left")) , parseInt($("#"+ID).css("top")) ) 

		return 





	saveFormToImg = ()->

		

		printTextToForm("name")
		printTextToForm("careerDay")
		

		printDayToForm("startDay")


		printDayToForm("finishDay")
		printTextToForm("availableDay")
		printTextToForm("useDay")



		printImgtoForm("PersonalMarkButton")
		printImgtoForm("DuptyMarkButton")
		printImgtoForm("supervisor")


		


		
		
		#bug should fix
		saveImgtoServer "upLoadForm", $("#Canvas")[0].toDataURL()
		return 


	saveImgtoServer =(url,data)->

		$.post url,
				{image:data},
				(data,status)->
					 
					 return
		return


		return




	$("#submit").click(saveFormToImg)

	nameStr=$("#name").text()
	nameStr=nameStr.replace " ",""
	$('#PersonalMarkButton').click({p1:"./images/"+nameStr+".jpg"},showMark)

	$('#DuptyMarkButton').click({p1:"./images/"+nameStr+".jpg"},showMark)

	$('#supervisor').click({p1:"./images/"+nameStr+".jpg"},showMark)


	return





$(window).load ->

	renderForm = ()->
		ctx = $("#Canvas")[0].getContext('2d')
		form = $("#Form")[0]
		ctx.drawImage(form,0,0)

		return
	renderForm()


	$(".loader").fadeOut("slow")
	
	return
