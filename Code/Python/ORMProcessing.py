# $ cd /mnt/c/Users/crist/Google\ Drive/Research/Python/PythonScripts
# $ python3.9

# Import XML parser.
import xml.etree.ElementTree as ET

# Ask for class name.
x = input('Type in the class name: ')

# Canonicalize file.
# with open("Canister.xml", mode='w', encoding='utf-8') as out_file:
#     ET.canonicalize(from_file="/mnt/c/Users/crist/git/dfinity/docs/spec/ontology/orm_diagrams/Canister.orm", out=out_file)

# Load file into tree object.
# tree = ET.parse('/mnt/c/Users/crist/git/dfinity/docs/spec/ontology/orm_diagrams/Canister.xml') # Linux
tree = ET.parse('c:/Users/crist/git/dfinity/docs/spec/ontology/orm_diagrams/Canister.xml') # Windows

# Search for the element whose "Name" is the class name inputted above.
tbks = tree.find('.//*[@Name="%s"]' % x)
# print(tbks)

# Search for all elements representing classes connected to the class above.
list = tbks.findall('.//{http://schemas.neumont.edu/ORM/2006-04/ORMCore}PlayedRoles/')
#print(list)

final = []

# Traverse the tree to retrieve the names of the edges that connect the classes in `list`
# to our class. Will need to find some parents and grandparents first ("..").
for i in list:
    if tree.find('.//{http://schemas.neumont.edu/ORM/2006-04/ORMCore}ReadingOrder/{http://schemas.neumont.edu/ORM/2006-04/ORMCore}RoleSequence/{http://schemas.neumont.edu/ORM/2006-04/ORMCore}Role/[@ref="%s"][1]....//{http://schemas.neumont.edu/ORM/2006-04/ORMCore}Data' % i.get('ref')) is not None:
        final.append(tree.find('.//{http://schemas.neumont.edu/ORM/2006-04/ORMCore}ReadingOrder/{http://schemas.neumont.edu/ORM/2006-04/ORMCore}RoleSequence/{http://schemas.neumont.edu/ORM/2006-04/ORMCore}Role/[@ref="%s"][1]....//{http://schemas.neumont.edu/ORM/2006-04/ORMCore}Data' % i.get('ref')))

# Print out the names of the edges.
for f in final:
    print(f.text.removeprefix('{0} ').removesuffix(' {1}'))