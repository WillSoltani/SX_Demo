'''
Author: Kia Kalani
Version: 1.00
This module contains the implementation of patients.
Last revised: 9/30/24
'''

from flask import current_app, jsonify
from sqlalchemy import Column, Integer, String, ForeignKey, UniqueConstraint, and_
import server.DB.sxcustomer as sxcustomer

class SXPatient(current_app.config['DB']['base']):
    '''
    The ORM representation of SXPatient
    '''

    __tablename__ = 'sxpatient'
    # The primary key for the table
    sx_patient_id = Column(Integer, primary_key=True)
    # The customer's id that has the given patient
    sx_doctor_id = Column(Integer, ForeignKey(
        'sxcustomer.sx_customer_id',
        ondelete='cascade'
    ))
    # The name of the patient. It is also indexed for fast searching
    sx_patient_name = Column(String, nullable=False, index=True)
    # addition table arguments
    __tbale_args__ = (
        UniqueConstraint( # making sure combination of doctor and patient are unique
            'sx_patient_name',
            'sx_doctor_id',
            name='uix_sx_patient_name_sx_doctor_id'
        )
    )

    def __init__(self, o_doctor: sxcustomer.SXCustomer, s_name: str) -> None:
        '''
        The constructor.
        :param: o_doctor: the doctor instance
        :param: s_name: the name of the patient.
        '''
        self.sx_doctor_id = o_doctor.sx_customer_id
        self.sx_patient_name = s_name.upper()

def get_patient(o_customer: sxcustomer.SXCustomer, s_patient: str) -> SXPatient:
    '''
    A method for getting the patient based on the arguments.
    :param: o_customer: the customer instance.
    :param: s_patient: the name of the patient.
    :return: the patient instance if exists otherwise None.
    '''

    return current_app.config['DB']['session'].query(SXPatient).filter(
        and_(
            SXPatient.sx_doctor_id == o_customer.sx_customer_id,
            SXPatient.sx_patient_name == s_patient.upper()
        )
    ).first()

def add_patient(o_customer: sxcustomer.SXCustomer, s_patient: str) -> (str, int):
    '''
    A method for adding a new patient to the database.
    :param: o_customer: the customer instance.
    :param: s_patient: the name of the patient to be added.
    :return: the json response with status code.
    '''

    # error checking the patient.
    if get_patient(o_customer, s_patient):
        return jsonify({"message": "duplicate"}), 400
    
    # adding the patient instance
    o_patient = SXPatient(o_customer, s_patient)
    current_app.config['DB']['session'].add(o_patient)
    current_app.config['DB']['session'].commit()
    return jsonify({"message": "success"}), 200

def search_patient(o_customer: sxcustomer.SXCustomer, s_query: str, i_limit=10) -> (str, int):
    '''
    A method for searching for patients.
    :param: o_customer: the customer instance.
    :param: s_query: the search query.
    :param: i_limit: the limit of the items to return for the search.
    :return: a json response with a status code.
    '''

    # executing the query
    s_query = s_query.upper()
    lo_resp: list[SXPatient] = current_app.config['DB']['session'].query(
        SXPatient
    ).filter(
        and_(
            SXPatient.sx_doctor_id == o_customer.sx_customer_id,
            SXPatient.sx_patient_name.startswith(s_query)
        )
    ).limit(i_limit).all()

    # returning the items as a json with a status code.
    return jsonify({
        "message": [{
            "name": o.sx_patient_name
        } for o in lo_resp]
    }), 200
