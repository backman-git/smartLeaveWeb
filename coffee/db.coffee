



mongoose = require('mongoose')


dbUrl = 'mongodb://localhost:27017/SmartLeave'
mongoose.connect(dbUrl)

db=mongoose.connection

db.on('error', console.error.bind(console, 'connection error:'))
db.once('open',()->
	return
	
)


module.exports= db