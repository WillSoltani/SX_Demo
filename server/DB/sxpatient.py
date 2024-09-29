from flask import current_app
from sqlalchemy import Column, Integer, String, ForeignKey


class SXPatient(current_app.config['DB']['base']):
    __tablename__ = 'sxpatient'
    sx_patient_id = Column(Integer, primary_key=True)
    sx_doctor_id = Column(Integer, ForeignKey(
        'sxcustomer.sx_customer_id',
        ondelete='cascade'
    ))
    sx_patient_customer_id = (Integer)
    sx_patient_name = Column(String, nullable=False, index=True)

