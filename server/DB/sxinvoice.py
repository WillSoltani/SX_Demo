import enum
from flask import current_app
from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Enum, Boolean

class SXInvoiceStatus(enum.Enum):
    FINISH = 0
    TRYIN = 1
    MODIFIED = 2
    VOID = 3

class SXInvoice(current_app.config['DB']['base']):
    __tablename__ = 'sxinvoice'
    sx_invoice_id = Column(Integer, primary_key=True, index=True)
    sx_patient_id = Column(ForeignKey("sxpatient.sx_patient_id", ondelete='cascade'))
    sx_customer_id = Column(ForeignKey("sxcustomer.sx_customer_id", ondelete='cascade'))
    sx_date = Column(DateTime) # should be now by default
    sx_due_date = Column(DateTime)
    sx_invoice_status = Column(Enum(SXInvoiceStatus), default=SXInvoiceStatus.FINISH)

class SXInvoiceItem(current_app.config['DB']['base']):
    __tablename__ = 'sxinvoiceitem'
    # Disregard sx_invoice_item_id. It is the primary key of the table and has nothing to do with the logic
    sx_invoice_item_id = Column(Integer, primary_key=True)
    sx_invoice_id = Column(ForeignKey("sxinvoice.sx_invoice_id", ondelete="cascade"), index=True)
    sx_product_id = Column(ForeignKey("sxproduct.sx_product_id", ondelete="cascade"))
    sx_invoice_item_count = Column(Integer)


class SXInvoiceReturn(current_app.config['DB']['base']):
    __tablename__ = 'sxinvoicereturn'
    sx_invoice_return_id = Column(Integer, primary_key=True)
    sx_invoice_id = Column(ForeignKey('sxinvoice.sx_invoice_id', ondelete='cascade'), index=True)
    sx_description = Column(String)
    sx_warranty_coverage = Column(Boolean)
