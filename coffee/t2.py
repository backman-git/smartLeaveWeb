



SM =require "./SecurityManager"



pageID =SM.getPageID()

console.log SM.queryAccount(pageID)

SM.sendCertification("0933216219",pageID)


console.log SM.queryAccount(pageID)