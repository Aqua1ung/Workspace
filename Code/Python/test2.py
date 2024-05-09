def oddNumbers(l, r):

    arr = []

    for i in range(l, r+1):
    	if not(i%2 == 0):
    		arr.append(i)
    return arr

lst = oddNumbers(2, 7)
print(lst)