


$(document).ready ->






	logOut=()->
		document.cookie="ID=; expires=Thu, 01 Jan 1970 00:00:00 UTC;"
		window.location.href = "../login"
		console.log "out"
		return 


	$("#logOut").click(logOut)

	return
