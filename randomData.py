from faker import Faker
from faker.providers import BaseProvider
import random
import csv
import string
import datetime

fake = Faker()

passwordLength = 12
employeeCodeLength = 20
characterList = ['a','b','c','y','f','g','0','1','2','3','4','5','6','7','8','9','!','@','#','*','?','<','>']
characterListEmployee = ['a','b','c','y','f','g','0','1','2','3','4','5','6','7','8','9']


class UnitProvider(BaseProvider):
    def unit_type(self):
        unit_short = ['oz', 'lb', 'g', 'kg', 'l']
        unit_long = ['ounce', 'pound', 'gram', 'kilogram', 'liter']
        number = random.randint(0, 4)
        return [unit_short[number], unit_long[number]]
    
class CatalogProvider(BaseProvider):
    def Catalog_type(self):
        Catalog_short = ['sent', 'received', 'delivered', 'cancelled', 'confirmed']
        number = random.randint(0, 4)
        return Catalog_short[number]

fake.add_provider(UnitProvider)
fake.add_provider(CatalogProvider)


city_postal_dict = {}

def get_customer_name():
    name = fake.name().split()
    return name

def get_employee_name():
    name = fake.name().split()
    return name

def get_city():
    city = fake.city()
    postal_code = ""
    while True:
        if city not in city_postal_dict:
            postal_code = fake.postalcode()
            city_postal_dict[city] = postal_code
            break
        elif city in city_postal_dict and postal_code not in city_postal_dict.values():
            postal_code = fake.postalcode()
            city_postal_dict[city] = postal_code
            break
        else:
            postal_code = fake.postalcode()
    return [city, postal_code]

def get_delivery_address():
    return fake.street_address()

def get_user_email():
    return fake.ascii_safe_email()

def get_user_phone():
    return fake.phone_number()

def get_user_password():
    password = []
 
    for i in range(passwordLength):
   
    # Picking a random character from our
    # character list
        randomchar = random.choice(characterList)
     
        # appending a random character to password
        password.append(randomchar)

    return "".join(password)

def get_employee_code():
    code = []
 
    for i in range(employeeCodeLength):
   
    # Picking a random character from our
    # character list
        randomchar = random.choice(characterListEmployee)
     
        # appending a random character to code
        code.append(randomchar)

    return "".join(code)

def get_username():
    return fake.simple_profile().get('username')

def get_date():
    return fake.date()

def get_confirmation_code():
    code_length = 8
    letters = string.ascii_uppercase + string.digits
    return ''.join(random.choice(letters) for i in range(code_length))

def get_time_inserted():
    return fake.date_time_between(start_date=datetime.datetime.now(), end_date=datetime.datetime.now() + datetime.timedelta(minutes=5))
   
def get_time_confirmed():
    time_confirmed = get_time_inserted() + datetime.timedelta(minutes=random.randint(0, 5))
    return time_confirmed

#  funciones para definir la tabla de order_status


# funciones para definir la tabla de status_catalog 


# funciones para definir la tabla de notes 


# funciones para definir la tabla de box


# funciones para definir la tabla de box_status


# funciones para definir la tabla de delivery


# funciones para definir la tabla de placed_order


# funciones para definir la tabla de order_item

def generate_groceryStore():
    unitTypes = fake.unit_type()
    return [get_customer_name()[0], get_customer_name()[1],get_username(),get_user_password(),
            get_date(),get_delivery_address(),get_delivery_address(),get_user_email(),
            get_user_phone(),get_confirmation_code(),get_employee_code(),get_employee_name()[0],
            get_employee_name()[1],get_city()[0],get_city()[1],
            unitTypes[1],unitTypes[0],get_time_inserted(),get_time_confirmed()]

with open('groceryStoreData.csv', 'w') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['CustomerFirstName','CustomerLastName','CustomerUserName','CustomerPassword',
                     'UserTimeInserted','CustomerAddress','CustomerDeliveryAddress',
                     'CustomerEmail','CustomerPhone','CustomerConfirmationCode','EmployeeCode',
                     'EmployeeFirstName','EmployeeLastName','CityName','CityPostalCode',
                     'UnitName','UnitShort','TimeInserted','TimeConfirmed'])
     writer.writerow(generate_groceryStore())
