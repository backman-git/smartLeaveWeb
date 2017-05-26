





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
		$(this).css("height","80px"  )
		$(this).css("width","200px"  )
		$(this).css("left","300px"  )
		return


	printTextToForm=(ID)->
		ctx = $("#Canvas")[0].getContext('2d')
		#name

		#BX bypass should fix
		if ID=="startH" or ID=="finishH"
			ctx.font = "20px DFKai-sb"
		else	
			ctx.font = "40px DFKai-sb"
		x=parseInt ( $("#"+ID).css("left") )
	
		
		y=parseInt( $("#"+ID).css("top") )
		#bias
		y+=40

		#BX bad bypass
		ctx.fillText($("#"+ID).val(), x , y )
		ctx.fillText($("#"+ID).text(), x , y )
		
		return

	printDayToForm=(ID)->
		ctx = $("#Canvas")[0].getContext('2d')

		ctx.font = "20px Arial"
		p=$("#"+ID).offset()		
		#bias
		ctx.fillText($("#"+ID).val(), p.left+30 , p.top )
		
		return


	printImgtoForm=(ID)->
		ctx = $("#Canvas")[0].getContext('2d')
		imageFactory =new ImageFactory ctx
		bgImg=$("#"+ID).css("background-image")
		bgImg=bgImg.replace('url(','').replace(')','').replace(/\"/gi, "")
		imageFactory.drawImage( bgImg , parseInt($("#"+ID).css("left")) , parseInt($("#"+ID).css("top")) ) 

		return 




	checkForm= ()->

		fDay=-1
		sDay=-1

		alertMsg=""

		switch $("#role").val()

			when "individual"

				#check day 
				fDay= new Date($('#finishDay').val())
				sDay= new Date($('#startDay').val())

				fDay_ms=fDay.getTime()
				sDay_ms=sDay.getTime()

				if isNaN(fDay) or isNaN(sDay)
					alertMsg+="日期未填!\n" 

				if sDay_ms>fDay_ms
					alertMsg+="結束時間小於開始時間!\n"

				if $('#PersonalMarkButton').text() !=""
					alertMsg+="請蓋章!\n"

				#should check if the person exist!
				if $('#deputyName').val()==""
					alertMsg+="代理人姓名空白!\n"


			when "deputy"
				if $('#DeputyMarkButton').text() !=""
					alertMsg+="請蓋章!\n"

			when "firstBoss"
				if $('#supervisorButton').text() !=""
					alertMsg+="請蓋章!\n"
			when "secondBoss"
				if $('#secondSupervisorButton').text() !=""
					alertMsg+="請蓋章!\n"


		if alertMsg=="" 
			#change use day
			diffDay= ( fDay_ms-sDay_ms )/(1000*60*60*24)
			$('#useDay').text(diffDay+$("#useDay").val())
			saveFormToImg(sDay,fDay)
		else
			alertMsg+="==============\n"
			alertMsg+="請完成上述資料"
			alert(alertMsg)


	delay =(ms,func) -> setTimeout func,ms

	saveFormToImg = (sDay,fDay)->

		
		if $('#team').length
			printTextToForm("team")

		if $('#name').length
			printTextToForm("name")
			
		if $('#title').length
			printTextToForm("title")
		
		if $('#careerDay').length
			printTextToForm("careerDay")
		
		if $('#startDay').length
			printDayToForm("startDay")

		if $('#finishDay').length
			printDayToForm("finishDay")

		if $('#availableDay').length
			printTextToForm("availableDay")

		if $('#useDay').length
			printTextToForm("useDay")

		if $("#PersonalMarkButton").length
			printImgtoForm("PersonalMarkButton")

		if $("#DeputyMarkButton").length
			printImgtoForm("DeputyMarkButton")

		if $("#supervisorButton").length
			printImgtoForm("supervisorButton")

		if $("#secondSupervisorButton").length
			printImgtoForm("secondSupervisorButton")

		if $("#officeMsg").length
			printTextToForm("officeMsg")
			console.log "office"
		if $("#etc").length
			printTextToForm('etc')
			console.log "etc"

		if $("#startH").length
			printTextToForm('startH')
		if $('#finishH').length
			printTextToForm('finishH')

		delay 30, ->saveImgtoServer sDay,fDay

		
		
		
		return 





	
	saveImgtoServer =(sDay,fDay)->

		url = "/mainPage/upLoadForm"
		data = $("#Canvas")[0].toDataURL()

	
		fType=""

		if fDay == -1 and sDay ==-1
			fType=null
		else if fDay-sDay <3
			fType="short"
		else
			fType="long"

		$.post url,
				{image:data,fID:$("#fID").val(),name:$("#name").text(),deputyName:$("#deputyName").val(),fType:fType  },
				(data,status)-> 

					if data =="指定代理人不存在"
						alert(data)
					else	
						window.location.href = "../mainPage"
					return
		return


		return
	


	cancelForm = (event)->
		url = "/mainPage/cancelForm"

		if confirm("確定取消假單?")
			$.post url,
				{name:event.data.name,fID:$("#fID").val()},
				(data,status)-> 
					window.location.href = "../mainPage"
					return
			return


		

		return 




	$("#submit").click(checkForm)

	$("#cancel").click({name:$("#editor").val()},cancelForm)

	pButtonID=$('#PersonalMarkButton').val()
	$('#PersonalMarkButton').click({p1:"../dataPool/mark/"+pButtonID+".png"},showMark)

	dButtonID=$('#DeputyMarkButton').val()
	$('#DeputyMarkButton').click({p1:"../dataPool/mark/"+dButtonID+".png"},showMark)

	sButtonID=$('#supervisorButton').val()
	$('#supervisorButton').click({p1:"../dataPool/mark/"+sButtonID+".png"},showMark)

	ssButtonID=$('#secondSupervisorButton').val()
	$('#secondSupervisorButton').click({p1:"../dataPool/mark/"+ssButtonID+".png"},showMark)


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
