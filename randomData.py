from faker import Faker
from faker.providers import BaseProvider
import random
import csv

fake = Faker()

passwordLength = 12
characterList = ['a','b','c','y','f','g','0','1','2','3','4','5','6','7','8','9','!','@','#','*','?','<','>']


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

def get_username():
    return fake.simple_profile().get('username')

def get_date():
    return fake.date()

def generate_groceryStore():
    return [get_customer_name()[0], get_customer_name()[1],get_username(),get_user_password(),get_date(),get_delivery_address(),get_user_email(),get_user_phone(),get_employee_name()[0],get_employee_name()[1],get_city()[0],get_city()[1]]

with open('groceryStoreData.csv', 'w') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['CustomerFirstName','CustomerLastName','CustomerUserName','CustomerPassword','UserTimeInserted','CustomerDeliveryAddress',
                     'CustomerEmail','CustomerPhone','EmployeeFirstName','EmployeeLastName','CityName','CityPostalCode'])
    for n in range(1, 100):
     writer.writerow(generate_groceryStore())
