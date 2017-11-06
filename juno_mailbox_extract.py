#!/usr/bin/python3

from bsddb3 import db
mailboxBDB = db.DB()
mailboxBDB.open('mailbox.bdb', dbtype=db.DB_BTREE)
cursor = mailboxBDB.cursor()
cursor.first()
rec = cursor.next() # skip the first record, it's only the DB version number
cntr = 1
fileNO = cntr

# while rec and cntr < 1000:
while rec:
	# print (rec)
	header = str(rec[0]) + "\n"
	raw = str(rec[1])
	if "+" not in header:
		fileNO = cntr
	email = open('./mdir/' + str(fileNO),'a')
	# email.write(header)
	email.write(raw[2:len(raw)-1].replace('\\n','\n'))
	email.close()
	cntr += 1
	rec = cursor.next()
	print (str(cntr) + '\n\n')

mailboxBDB.close()
