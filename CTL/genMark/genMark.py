
#-*- coding:utf8 -*-

from PIL import Image, ImageFont, ImageDraw










def genMark(name,dir):

	font = ImageFont.truetype('a.ttf',25)
	img = Image.new("RGB",(200,80),'white')
	draw = ImageDraw.Draw(img)
	draw.rectangle([0,0,300,80],outline="red",fill="red")
	draw.rectangle([5,5,195,75],outline="white",fill="white")
	draw.text((5,28),name,fill='red',font=font)


	del draw

	# write to stdout
	img.save(dir+"/"+name.replace(u"\ufeff","").replace(" ","").replace("\n","").replace("\t","")+".png", "PNG")




with open("./list.txt",'r',encoding='utf8') as f:

	for line in f.readlines():
		genMark(line,"./mark")