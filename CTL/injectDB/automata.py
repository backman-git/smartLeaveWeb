#-*- coding: utf-8 -*-


import requests
import pandas as pd   



injectData = pd.read_csv("./list.csv")


for i in range(len(injectData)):

	print(injectData["name"][i])
	payload= {"name":injectData["name"][i],"title":injectData["title"][i],"boss":injectData["boss"][i],"startCareerDate":injectData["startCareerDate"][i],"availableDay":injectData["availableDay"][i],"pwd":injectData["pwd"][i]}
	files ={'mark':open("../"+str(injectData["path"][i]),'rb')}
	r=requests.post("http://127.0.0.1:3000/newStaff",data=payload,files=files)

print(r.text)
