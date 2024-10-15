import enum
from flask import current_app, jsonify
from sqlalchemy import Column, Integer, String, ForeignKey,\
    DateTime, Enum, Boolean, Float, CheckConstraint, UniqueConstraint, and_,\
        select, literal


class SXProduct(current_app.config['DB']['base']):
    __tablename__ = 'sxproduct'
    sx_product_id = Column(Integer, primary_key=True, index=True)
    sx_product_name = Column(String, index=True, unique=True, nullable=False)
    sx_normal_rate = Column(Float, nullable=False)
    sx_ministery_rate = Column(Float, nullable=True)
    sx_product_description = Column(String)

    def __init__(self, s_name: str, f_normal_rate: float, f_min_rate: float, s_description: str) -> None:
        self.sx_product_name = s_name.upper()
        self.sx_normal_rate = f_normal_rate
        self.sx_ministery_rate = f_min_rate
        self.sx_product_description = s_description

class SXProductAggregate(current_app.config['DB']['base']):
    __tablename__ = 'sxproductaggregate'
    sx_aggregate_id = Column(Integer, primary_key=True)

    sx_product_id = Column(
        Integer,
        ForeignKey('sxproduct.sx_product_id', ondelete='cascade'),
        index=True
    )
    sx_agg_product_id = Column(
        Integer,
        ForeignKey('sxproduct.sx_product_id', ondelete='cascade'),
    )

    sx_count_aggregate = Column(
        Integer
    )

    __table_args__ = (
        CheckConstraint(
            'NOT (sx_product_id = sx_agg_product_id)',
            name='constraint_not_sx_product_id_equals_sx_agg_product_id'
        ),
        UniqueConstraint(
            'sx_product_id',
            'sx_agg_product_id',
            name='uix_sx_product_id_sx_agg_product_id'
        )
    )

    def __init__(self, o_prod: SXProduct, o_dest: SXProduct, i_count: int = 1) -> None:
        self.sx_product_id = o_prod.sx_product_id
        self.sx_agg_product_id = o_dest.sx_product_id
        self.sx_count_aggregate = i_count

def get_product(s_name: str) -> SXProduct:
    return current_app.config['DB']['session'].query(SXProduct).where(
        SXProduct.sx_product_name == s_name.upper()
    ).first()

def add_product(s_name: str, f_normal_rate: float, s_description: str, f_min_rate: float = None) -> (str, int):
    if get_product(s_name):
        return jsonify({"message": "duplicate"}), 400
    f_min_rate = f_normal_rate if (f_min_rate is None) else f_min_rate
    o_prod = SXProduct(s_name, f_normal_rate, f_min_rate, s_description)
    current_app.config['DB']['session'].add(o_prod)
    current_app.config['DB']['session'].commit()
    return jsonify({"message": "success"}), 200

def update_product_name(s_name: str, s_new_name: str) -> (str, int):
    if get_product(s_new_name):
        return jsonify({"message": "duplicate"}), 400
    o_product = get_product(s_name)
    if not o_product:
        return jsonify({"message": "invalid"}), 400
    o_product.sx_product_name = s_new_name
    current_app.config['DB']['session'].commit()
    return jsonify({"message": "success"}), 200

def update_product_normal_rate(s_name: str, f_rate: float) -> (str, int):
    o_product = get_product(s_name)
    if not o_product:
        return jsonify({"message": "invalid"}), 400
    o_product.sx_normal_rate = f_rate
    current_app.config['DB']['session'].commit()
    return jsonify({"message": "success"}), 200

def update_product_ministery_rate(s_name, f_rate: float) -> (str, int):
    o_product = get_product(s_name)
    if not o_product:
        return jsonify({"message": "invalid"}), 400
    o_product.sx_ministery_rate = f_rate
    current_app.config['DB']['session'].commit()
    return jsonify({"message": "success"}), 200

def update_product_description(s_name: str, s_desc: str) -> (str, int):
    o_product = get_product(s_name)
    if not o_product:
        return jsonify({"message": "invalid"}), 400
    o_product.sx_product_description = s_desc
    current_app.config['DB']['session'].commit()
    return jsonify({"message": "success"}), 200

def define_aggregate(s_prod: str, s_agg_prod: str, i_count: int = 1) -> (str, int):
    o_prod = get_product(s_prod)
    if not o_prod:
        return jsonify({"message": "invalid"}), 400
    o_dest = get_product(s_agg_prod)
    if not o_dest:
        return jsonify({"message": "invalid dest"}), 400
    if current_app.config['DB']['session'].query(SXProductAggregate).filter(
        and_(
            SXProductAggregate.sx_product_id == o_prod.sx_product_id,
            SXProductAggregate.sx_agg_product_id == o_prod.sx_product_id
        )
    ).first():
        return jsonify({"message": "invalid"}), 400
    o_agg = SXProductAggregate(o_prod, o_dest, i_count)
    current_app.config['DB']['session'].add(o_agg)
    current_app.config['DB']['session'].commit()
    return jsonify({"message": "success"}), 200
    
    
def remove_aggregate(s_prod: str, s_agg_prod: str, i_count: int) -> (str, int):
    o_prod = get_product(s_prod)
    if not o_prod:
        return jsonify({"message": "invalid"}), 400
    o_dest = get_product(s_agg_prod)
    if not o_dest:
        return jsonify({"message": "invalid dest"}), 400
    o_agg = current_app.config['DB']['session'].query(
        SXProductAggregate
    ).filter(
        and_(
            SXProductAggregate.sx_product_id == o_prod.sx_product_id,
            SXProductAggregate.sx_agg_product_id == o_prod.sx_product_id
        )
    ).first()
    if not o_agg:
        return jsonify({"message": "invalid aggregate"}), 400
    current_app.config['DB']['session'].delete(o_agg)
    current_app.config['DB']['session'].commit()
    return jsonify({"message": "success"}), 200

def get_product_and_aggregates(s_prod: str) -> (str, int):
    pass
