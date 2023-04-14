from faker import Faker
from faker.providers import BaseProvider
import random
import csv
import string
from datetime import datetime, timedelta

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

def get_name():
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

def get_address():
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
   return fake.date_between(start_date='-5y', end_date='today')

def get_time_confirmed():
    days_until_confirmed = random.randint(1, 14)
    return get_time_inserted() + timedelta(days=days_until_confirmed)

def generate_names():
    return [get_name()[0]]

def generate_last_names():
    return [get_name()[1]]

def generate_usernames():
    return [get_username()]

def generate_passwords():
    return [get_user_password()]

def generate_user_email():
    return [get_user_email()]

def generate_user_phone():
    return [get_user_phone()]

def generate_city():
   return[get_city()[0],get_city()[1]]

def generate_address():
   return [get_address()]

def generate_delivery_address():
   return [get_delivery_address()]

def generate_confirmation_code():
    return [get_confirmation_code()]

def generate_time_inserted():
   return [get_time_inserted()]

def generate_time_confirmed():
   return[get_time_confirmed()]

def generate_employee_code():
    return [get_employee_code()]

with open('namesData.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['Name'])
    for n in range(1, 500):
     writer.writerow(generate_names())

with open('lastNamesData.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['LastName'])
    for n in range(1, 500):
     writer.writerow(generate_last_names())

with open('usernamesData.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['Username'])
    for n in range(1, 1000):
     writer.writerow(generate_usernames())

with open('passwordsData.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['Password'])
    for n in range(1, 1000):
     writer.writerow(generate_passwords())

with open('userEmailsData.csv', 'w',newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['Email'])
    for n in range(1, 1000):
     writer.writerow(generate_user_email())

with open('cityPostalCode.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['City','PostalCode'])
    for n in range(1, 1000):
     writer.writerow(generate_city())

with open('address.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['Address'])
    for n in range(1, 500):
     writer.writerow(generate_address())

with open('deliveryAddress.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['deliveryAddress'])
    for n in range(1, 500):
     writer.writerow(generate_delivery_address())

with open('userPhonesData.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['Phone'])
    for n in range(1, 1000):
     writer.writerow(generate_user_phone())

with open('confirmationCodesData.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['ConfirmationCode'])
    for n in range(1, 1000):
     writer.writerow(generate_confirmation_code())

with open('timeInserted.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['timeInserted'])
    for n in range(1, 1000):
     writer.writerow(generate_time_inserted())

with open('timeConfirmed.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['timeConfirmed'])
    for n in range(1, 1000):
     writer.writerow(generate_time_confirmed())

with open('employeeCodesData.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['EmployeeCode'])
    for n in range(1, 1000):
     writer.writerow(generate_employee_code())

