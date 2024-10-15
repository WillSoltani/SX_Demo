'''
Author: Kia Kalani
Version: 1.00
This module is responsible for providing the user
with the authorization features.
Last revised: 9/24/24
'''

from flask import current_app, Blueprint, jsonify, request
import server.DB.sxuser as user

bp = Blueprint("auth", __name__, url_prefix='/auth')

@bp.route("/signin", method=['POST'])
def signin():
    '''
    This method gets invoked when the user
    is trying to make a sign in request.
    '''
    # error checking the keys
    as_needed_keys = ['username', 'password']
    json_req = request.get_json()
    for s_key in as_needed_keys:
        if s_key not in json_req:
            return jsonify({"message": "invalid"}), 400
    
    # Letting the rest to be handled by the model
    return user.login_sx_user(
        json_req['username'],
        json_req['password']
    )

@bp.route("/signup", method=['POST'])
def signup():
    '''
    This method gets invoked when users try
    to make a sign up request.
    '''
    # the required keys inside the form
    as_needed_keys = ['username', 'password', 'repeat_password']

    json_req = request.get_json()
    # Making sure the required keys are provided
    for s_key in as_needed_keys:
        if s_key not in json_req:
            return jsonify({"message": "invalid"}), 400
    
    # Making sure the password and repeat password are the same
    if json_req['password'] != json_req['repeat_password']:
        return jsonify({"message": "invalid"}), 400
    
    # Letting the model handle the addition after this step
    return user.register_sx_user(
        json_req['username'],
        json_req['password'],
        user.SXUserType.CLIENT
    )

@bp.route("/checktoken")
def checktoken():
    token = request.headers.get("Auth-Token")
    if user.get_sx_user(token) is None:
        return jsonify({"message": "invalid"}), 400
    return jsonify({"message": "success"}), 200
