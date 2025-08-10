'''
Author: Kia Kalani
Version: 1.00
This module is responsible for registering
all of the necessary modules to the main
application.
Last revised: 9/24/24
'''

from flask import current_app


def init():
    '''
    A method for initializing all of the blueprints.
    '''
    import server.REST.auth as auth
    current_app.register_blueprint(auth.bp)
