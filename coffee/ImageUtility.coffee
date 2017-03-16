


$(document).ready ->

	$("#Form").hide()
	ctx = $("#Canvas")[0].getContext('2d');





	ImageFactory =(ctx)->
		this.ctx=ctx
		this.drawImage = (image_arg,image_x,image_y)->
			_this= this
			image = new Image()
			image.src=image_arg
			image.onload = () ->
				_this.ctx.drawImage(image,image_x,image_y)
				return 
			return
		return


	renderForm = ()->
		form = $("#Form")[0]
		ctx.drawImage(form,0,0)

		return
	
	renderForm();




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


	saveFormToImg = ()->

		widthBias=0
		heightBias=0


		ctx = $("#Canvas")[0].getContext('2d')
		imageFactory =new ImageFactory ctx
		ctx.font = "50px Arial"

		ctx.fillText($("#name").text(), parseInt( $("#name").css("top")),parseInt ($("#name").css("left") )  )
		
		bgImg=$("#PersonalMarkButton").css("background-image")
		bgImg=bgImg.replace('url(','').replace(')','').replace(/\"/gi, "")




		#drawMark
		console.log bgImg
		imageFactory.drawImage( bgImg , parseInt($("#PersonalMarkButton").css("left")) , parseInt($("#PersonalMarkButton").css("top")) ) 

		

		saveImgtoServer "upLoadForm", $("#Canvas")[0].toDataURL()
		return 


	saveImgtoServer =(url,data)->

		$.post url,
				{image:data},
				(data,status)->
					 alert("Data: " + data + "\nStatus: " + status);
					 return
		return


		return




	$("#submit").click(saveFormToImg)

	$('#PersonalMarkButton').click({p1:"./images/personalMark.jpg"},showMark)

	$('#DuptyMarkButton').click({p1:"./images/personalMark.jpg"},showMark)

	$('#supervisor').click({p1:"./images/personalMark.jpg"},showMark)


	return

