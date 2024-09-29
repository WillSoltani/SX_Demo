import re
from flask import current_app
from sqlalchemy import Column, Integer, String, ForeignKey

class SXCustomer(current_app.config['DB']['base']):
    '''
    An orm model for representing the customer.
    '''
    __tablename__ = 'sxcustomer'
    sx_customer_id = Column(Integer, primary_key=True, index=True)
    sx_customer_name = Column(String, unique=True, index=True)
    sx_customer_addr = Column(String, index=True)
    sx_customer_phone = Column(String, index=True)
    sx_customer_email = Column(String)
    def __init__(
        self,
        s_customer_name: str,
        s_customer_addr: str,
        s_customer_phone: str,
        s_customer_email: str
    ) -> None:
        self.sx_customer_name = s_customer_name
        self.sx_customer_addr = s_customer_addr
        self.sx_customer_phone = s_customer_phone
        self.sx_customer_email = s_customer_email

def add_customer(s_name, s_addr, s_phone, s_email=None) -> None:
    o_pattern = re.compile(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
    if not (s_email and o_pattern.match(s_email)):
        s_email = None

