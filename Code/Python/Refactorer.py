import re
y = input('Enter the filename in the current folder: ')
with open(y, 'r') as text:
    string = text.read()
stringl = string.split()
#print('Enter the prefix: ')
x = input('Enter the prefix: ')
curl = list()
for o in stringl:
    if x in o:
        curl.append(o)# this works fine
#    	stringl.remove(o)# this doesn't work
#print(stringl)# this doesn't work
#print(curl)# this works fin'e
#curl3 = list()
for o in curl:
    o1 = o[o.find(':'):].split('-')
    curl2 = list()
    for o2 in o1[1:]:
#       curl2.append(o2.capitalize())# this unfortunately not only capitalizes the first letter, but turns all the other into small letters! Go figure!
        curl2.append(o2[:1].upper() + o2[1:])
    o3 = o[:o.find(':')] + o1[0] + ''.join(curl2)
#   o4 = o3.replace(o3[0], o3[0].lower(), 1)
#   curl3.append(o4)
    string = string.replace(o, o3)
#print(curl3)
#print(string)
with open('fibo.ttl', 'w') as text:
    text.write(string)