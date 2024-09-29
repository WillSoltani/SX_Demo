import enum
from flask import current_app
from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Enum, Boolean, Float


class SXProduct(current_app.config['DB']['base']):
    __tablename__ = 'sxproduct'
    sx_product_id = Column(Integer, primary_key=True)
    sx_product_name = Column(String, index=True, unique=True, nullable=False)
    sx_normal_rate = Column(Float, nullable=False)
    sx_ministery_rate = Column(Float, nullable=True)
    sx_product_description = Column(String)

class SXProductAggregate(current_app.config['DB']['base']):
    __tablename__ = 'sxproductaggregate'
    sx_aggregate_id = Column(Integer, primary_key=True)

    sx_product_id = Column(ForeignKey('sxproduct.sx_product_id', ondelete='cascade'), index=True)
    sx_agg_product_id = Column(ForeignKey('sxproduct.sx_product_id', ondelete='cascade'), index=True)
