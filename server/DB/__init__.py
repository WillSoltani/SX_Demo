'''
Author: Kia Kalani
Version: 1.00
This module is responsible for setting up the
database all around the project.
Last Revised: 9/24/24
'''
from flask import current_app
from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker, declarative_base

def init():
    '''
    A method for setting up the database and add
    all the necessary models.
    '''
    # Creating db instance
    engine = create_engine(f'sqlite:///test.db')
    db_session = scoped_session(sessionmaker(autoflush=False, bind=engine))
    base = declarative_base()
    base.query = db_session.query_property()

    current_app.config['DB'] = {
        'engine': engine,
        'session': db_session,
        'base': base
    }

    # Loading all of the orm models
    from server.DB.sxuser import SXUser
    base.metadata.create_all(bind=engine)
    
def teardown():
    '''
    A method for removing the database instance
    after the server stops running.
    '''
    @current_app.teardown_appcontext
    def remove_db(exc=None):
        current_app.config['DB']['session'].remove()

