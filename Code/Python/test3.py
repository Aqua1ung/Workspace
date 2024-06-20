# x = "129.7"
# #print(round(float(x), 2))
# z = float(x)
# y = format(z, '.2' 'f')
# print(y)
#print(float(format(x, .2)))
#u = print(type(y))
#print(u)
#print(float(y) == z)
# import sys
# print(sys.version)
from comment_parser import comment_parser
comment_parser.extract_comments('/home/dad/Git/Workspace/Code/Python/Refactorer.py', mime='text/x-python')