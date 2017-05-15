// Generated by CoffeeScript 1.12.3
(function() {
  var People, PeopleSchema, mongoose;

  mongoose = require('mongoose');

  PeopleSchema = mongoose.Schema({
    name: String,
    boss: String,
    level: Number,
    title: String,
    startCareerDate: String,
    availableDay: Number,
    useDay: Number,
    pwd: String,
    waitHQueue: {}
  });

  PeopleSchema.methods.addFormToWaitHQueue = function(form) {
    return this.waitHQueue[form.fileID] = form;
  };

  PeopleSchema.methods.getWaitHQueue = function() {
    return this.waitHQueue;
  };

  PeopleSchema.methods.retriveFormByFID = function(FID) {
    var form;
    form = this.waitHQueue[FID];
    delete this.waitHQueue[FID];
    return form;
  };

  PeopleSchema.methods.setUseDay = function(n) {
    this.useDay = n;
  };

  PeopleSchema.methods.getUseDay = function(n) {
    var out;
    out = this.useDay;
    return out;
  };

  People = mongoose.model('people', PeopleSchema);

  '\n\ndbUrl = \'mongodb://localhost:27017/SmartLeave\'\nmongoose.connect(dbUrl)\n\ndb=mongoose.connection\n\ndb.on(\'error\', console.error.bind(console, \'connection error:\'))\ndb.once(\'open\',()->\n	console.log "Leave System connect to database"\n\n)\n\n\n\n\np1= new People({name:"假單庫",boss:"",level:0,title:"",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})\np2= new People({name:"林子博",boss:"假單庫",level:1,title:"分隊長",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})\np3= new People({name:"許木坤",boss:"林子博",level:2,title:"隊員",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})\np4= new People({name:"楊易山",boss:"林子博",level:2,title:"隊員",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})\np5= new People({name:"林茂昌",boss:"林子博",level:2,title:"隊員",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})\np6= new People({name:"涂邑憲",boss:"林子博",level:2,title:"隊員",startCareerDate:"201701/01",availableDay:25,useDay:3,pwd:"123"})\np1.save()\np2.save()\np3.save()\np4.save()\np5.save()\np6.save()';

  module.exports = People;

}).call(this);