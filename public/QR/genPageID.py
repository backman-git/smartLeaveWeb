
import png
import pyqrcode

#with URL!!
msg="http://192.168.0.103:3000/security/sendCertification?tagID="

for i in range(100):
	code = pyqrcode.create(msg+str(i), error='L', version=27, mode='binary')
	qrPic=code.png('code'+str(i)+'.png', scale=1, module_color=[0, 0, 0, 128], background=[0xff, 0xff, 0xff])

