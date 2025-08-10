'''
Author: Kia Kalani
Version: 1.00
This module contains the definition of SXUser.
Last Revised: 9/24/24
'''
import enum
import re
from flask import current_app, jsonify
from werkzeug.security import generate_password_hash, check_password_hash
from sqlalchemy import Column, Integer, Enum, String
import jwt

class SXUserType(enum.Enum):
    '''
    An enum to determine the type of user we are dealing
    with
    '''
    ADMIN = 0,
    CLIENT = 1

class SXUser(current_app.config['DB']['base']):
    '''
    The user instance for the project
    '''
    __tablename__ = "sxuser"
    sx_username = Column(String, primary_key=True, index=True)
    sx_password = Column(String, nullable=False)
    sx_usertype = Column(Enum(SXUserType), nullable=False)

    def __init__(self, s_username: str, s_password: str, e_usertype: SXUserType):
        '''
        The constructor for setting the values
        :param: s_username: the username provided as a string
        :param: s_password: the password
        :param: e_usertype: the user type defined as either admin or client
        '''
        self.sx_username = s_username
        self.sx_password = s_password
        self.sx_usertype = e_usertype

def get_sx_user(s_token: str) -> SXUserType:
    '''
    A getter method for the logged in user based on
    the credentials.
    :param: s_token: The user's token
    :return: The user instance based on their token
    '''
    try:
        s_username = current_app.config['TOKEN_PARSE'](s_token)
        return current_app.config['DB']['session'].query(SXUser).filter(
            SXUser.sx_username == s_username
        ).first()
    except jwt.ExpiredSignatureError:
        return None
    except jwt.InvalidSignatureError:
        return None
    except jwt.InvalidTokenError:
        return None
    return None

def register_sx_user(s_username: str, s_password: str, e_usertype: SXUserType) -> (str, int):
    '''
    A method for registering a new user.
    :param: s_username: a string indicating the username.
    :param: s_password: a string indicating the password.
    :return: the response as a json message and the status code.
    '''
    o_username_pattern = re.compile(r'^[a-zA-Z0-9_]{3,}$')
    o_password_pattern = re.compile(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')

    # Making sure username meets the requirements
    if not o_username_pattern.match(s_username):
        return jsonify({
            "message": "username"
        }), 400

    # Making sure password constraints are met
    if not o_password_pattern.match(s_password):
        return jsonify({
            "message": "password"
        }), 400

    # Making sure username does not already exist
    if current_app.config['DB']['session'].query(SXUser).where(
        SXUser.sx_username == s_username
    ).first():
        return jsonify({
            "message": "duplicate"
        }), 400

    # adding the user if everything is successful
    o_sxuser = SXUser(
        s_username,
        generate_password_hash(s_password),
        e_usertype
    )
    current_app.config['DB']['session'].add(o_sxuser)
    current_app.config['DB']['session'].commit()

    return jsonify({
        "message": "success"
    }), 200

def login_sx_user(s_username: str, s_password: str) -> (str, int):
    '''
    A method for logging in the user based on their credentials.
    :param: s_username: the username
    :param: s_password: the password
    :return: a json string and status code based on whether the login
    was successful or not.
    '''

    o_sxuser: SXUser = current_app.config[
        'DB'
    ]['session'].query(SXUser).where(
        SXUser.sx_username == s_username
    ).first()

    # Means username is invalid
    if o_sxuser is None:
        return jsonify({
            "message": "invalid"
        }), 400

    # Means password is correct
    if check_password_hash(o_sxuser.sx_password, s_password):
        return jsonify({
            "message": current_app.config['TOKEN_CREATE'](o_sxuser.sx_username)
        }), 200

    # In any other case, password is invalid
    return jsonify({
        "message": "invalid"
    }), 400
