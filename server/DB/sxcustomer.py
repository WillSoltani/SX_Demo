'''
Author: Kia Kalani
Version: 1.00
This module is responsible for handling
all the events corresponding to the customer.
Last Revision: 9/30/24
'''

import re
from flask import current_app, jsonify
from sqlalchemy import Column, Integer, String, ForeignKey, Index, func, or_

class SXCustomer(current_app.config['DB']['base']):
    '''
    An orm model for representing the customer.
    '''

    __tablename__ = 'sxcustomer'
    # id of the customer stored as the primary key.
    sx_customer_id = Column(Integer, primary_key=True)
    # customer's name. This name must be unique
    sx_customer_name = Column(String, unique=True, index=True)
    # customer's address
    sx_customer_addr = Column(String, index=True)
    # customer's phone number
    sx_customer_phone = Column(String, index=True)
    # Customer's email
    sx_customer_email = Column(String, index=True)

    def __init__(
        self,
        s_customer_name: str,
        s_customer_addr: str,
        s_customer_phone: str,
        s_customer_email: str
    ) -> None:
        '''
        Constructor for setting the initial values. Note that
        for the purpose of indexing, everything is stored as
        upper case.
        '''

        self.sx_customer_name = s_customer_name.upper()
        self.sx_customer_addr = s_customer_addr.upper()
        self.sx_customer_phone = s_customer_phone
        self.sx_customer_email = s_customer_email.upper()

def add_customer(s_name: str, s_addr: str, s_phone: str, s_email=None) -> (str, int):
    '''
    A method that is responsible for addding a new customer
    to the database.
    :param: s_name: a string to set the name of the customer
    :param: s_addr: a string that sets the address for the customer
    :param: s_phone: The phone number
    :param: s_email: refers to the customer's email
    :return: the server's response to the operation.
    '''
    # patterns for email and phone numbers
    o_email_pattern = re.compile(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
    o_phone_number_pattern = re.compile(r'^\+[1-9]\d{1,14}$')

    # error checking email
    if not (s_email and o_email_pattern.match(s_email)):
        s_email = None

    # error checking phone number
    if not o_phone_number_pattern.match(s_phone):
        return jsonify({
            'message': 'invalid phone number'
        }), 400

    # Error check the name
    if current_app.config['DB']['session'].query(SXCustomer).where(
        SXCustomer.sx_customer_name == s_name.upper()
    ).first():
        return jsonify({
            "message": "duplicate"
        }), 400
    
    # means everything is done correctly. We just add the new customer
    o_customer = SXCustomer(s_name, s_addr, s_phone, s_email)
    current_app.config['DB']['session'].add(o_customer)
    current_app.config['DB']['session'].commit()
    return jsonify({
        "message": "success"
    }), 200

def get_customer(s_name: str) -> SXCustomer:
    '''
    A method for getting the customer by the provided name.
    :param: s_name: The destined name.
    :return: a customer instance or null if it doesn't exist.
    '''

    return current_app.config['DB']['session'].query(SXCustomer).where(
        SXCustomer.sx_customer_name == s_name.upper()
    ).first()

def search_customer(s_query: str, i_limit=10) -> (str, int):
    '''
    A method that allows searching for customers through their name, address,
    email, and phone number.
    :param: s_query: the query string
    :param: i_limit: an integer to limit the number of items
    returned from the query.
    :return: the response json with status code.
    '''

    # since all fields are upper case
    s_query = s_query.upper()

    # Querying for customers.
    lo_q_res: list[SXCustomer] = current_app.config['DB']['session'].query(
        SXCustomer
    ).filter(
        or_(
            or_(
                or_(
                    SXCustomer.sx_customer_name.startswith(s_query),
                    SXCustomer.sx_customer_addr.startswith(s_query)
                ),
                SXCustomer.sx_customer_phone.startswith(s_query)
            ),
            SXCustomer.sx_customer_email.startswith(s_query)
        )
    ).limit(i_limit).all()
    
    # Providing the result
    return jsonify({
        'message': [{
            'name': o.sx_customer_name.title(),
            'address': o.sx_customer_addr.title(),
            'email': o.sx_customer_email.lower(),
            'phone': o.sx_customer_phone
        } for o in lo_q_res]
    }), 200

def update_customer_email(s_customer: str, s_email: str) -> (str, int):
    '''
    A method for updating the customer's email address.
    :param: s_customer: the customer name
    :param: s_email: the customer's new email.
    :return: json response with status code.
    '''

    # retrieving the customer
    o_customer = get_customer(s_customer)
    if o_customer is None:
        return jsonify({"message", "invalid customer"}), 400
    
    # error checking the email
    o_email_pattern = re.compile(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
    if not o_email_pattern.match(s_email):
        return jsonify({"message": "invalid email"}), 400

    # updating the email
    o_customer.sx_customer_email = s_email
    current_app.config['DB']['session'].commit()
    return jsonify({"message": "success"}), 200

def update_customer_address(s_customer: str, s_address: str) -> (str, int):
    '''
    A method for updating the customer's address.
    :param: s_customer: the customer's name
    :param: s_address: customer's new address.
    :return: the json response with status code.
    '''

    # retrieving the customer
    o_customer = get_customer(s_customer)
    if o_customer is None:
        return jsonify({"message", "invalid customer"}), 400
    
    # updating the customer's address
    o_customer.sx_customer_addr = s_address
    current_app.config['DB']['session'].commit()
    return jsonify({'message': 'success'}), 200

def update_customer_phone_number(s_customer: str, s_number: str) -> (str, int):
    '''
    This method is responsible for updating the customer's phone number.
    :param: s_customer: the customer's name
    :param: s_number: the customer's new phone number
    :return: the json response with status code.
    '''

    # getting the customer
    o_customer = get_customer(s_customer)
    if o_customer is None:
        return jsonify({"message": "invalid customer"}), 400
    
    # error checking the phone number
    o_phone_number_pattern = re.compile(r'^\+[1-9]\d{1,14}$')
    if not o_phone_number_pattern.match(s_number):
        return jsonify({'message', 'invalid phone number'}), 400

    # updating the phone number
    o_customer.sx_customer_phone = s_number
    current_app.config['DB']['session'].commit()
    return jsonify({"message", "success"}), 200
