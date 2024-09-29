'''
Author: Kia Kalani
Version: 1.00
This module is responsible for assembling
the project together.
Last revised: 9/24/24
'''

from flask import Flask
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
import jwt

import server.DB as DB
import server.REST as REST

app = Flask('server', static_folder='static')

def setup_tokenization():
    '''
    This method sets up the tokenization for the
    application to allow users authenticating to
    the app.
    '''

    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=2048
    )

    public_key = private_key.public_key()

    pem_private = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption()
    )

    pem_public = public_key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    )

    # The lambda functions that perform the authentication
    app.config['TOKEN_CREATE'] = lambda a: jwt.encode(
        a,
        pem_private,
        algorithm="RS256"
    )
    app.config["TOKEN_PARSE"] = lambda a: jwt.decode(
        a,
        pem_public,
        algorithms=["RS256"]
    )

def setup_app():
    '''
    A method that performs all of the
    necessary setups for the app to function.
    '''
    with app.app_context():
        DB.init()
        DB.teardown()
        REST.init()
        setup_tokenization()

setup_app()

if __name__ == "__main__":
    app.run()

