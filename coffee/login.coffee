






define(['./securityQR'],(securityQR)->


	SQR=new securityQR()

	$(document).ready ->

		

		SQR.implantQR()

		SQR.on((data)->



			#Vulnerability should encrypt password or send session!   2017/06/08  Backman
			$.post "/login",{username:data["name"],pwd:data["pwd"]},(data,status)->

				console.log data+" "+status

				window.location.href = "../mainPage"



			)

		return


	)