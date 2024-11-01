# The general structure of a (great deal of) Python program(s). To be regarded as "best practice."

# Import statements:
import <module_name> [as <alias>]
...
from <module_name> import <list_of_objects_from_module>
...

# Function declarations:
def <function_name>(<list_of_function_parameters>):
    <function_body>
    return [<expression_based_on_variables_in_function_body>]
...

# Primitive class declarations:
class <class_name>:
    # Method declarations:
    def __init__(self, <list_of_object_parameters_to_initialize>): # Constructor method.
        # Block of assignment statements initializing all class parameters:
        self.<parameter_name> = <initial_value>
        ...
    def <method_name>(self):
        <method_body>        
    ...
...

# Subclass ("derived class") declarations:
class <subclass_name>(<class_name1>, <class_name2>, ...)
    # Method declarations:
    def <method_name>(self)
        <method_body>
    ...
...

if __name__ == '__main__':
    rc = 1
    try:
        <this_modules_main_body>
        rc = 0
    except <exception> as e:
        print(f'Error: {e}', file = sys.stderr)
    sys.exit(rc)