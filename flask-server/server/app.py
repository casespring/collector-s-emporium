from flask import Flask, make_response, jsonify, request, session
from flask_restful import Resource, Api, reqparse
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_cors import CORS
from dotenv import dotenv_values
from models import db, User, Collection, Comment, Like, Tag, Forum, Post, CommentOnPost, MarketPlaceItem, Followers, Bookmark
from werkzeug.security import generate_password_hash, check_password_hash
from flask_bcrypt import Bcrypt
from sqlalchemy.orm.exc import NoResultFound
from sqlalchemy.orm import joinedload
from flask_bcrypt import Bcrypt
import firebase_admin
from firebase_admin import credentials, auth
import os

app = Flask(__name__)
# config = dotenv_values('.env')
app.secret_key = "asdfwer2435asdrwr"
CORS(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///app.db'  
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
migrate = Migrate(app, db)
db.init_app(app)
bcrypt = Bcrypt(app)

# Initialize Firebase Admin SDK
cred = credentials.Certificate('../secrets/collector-s-emporium-firebase-adminsdk-cyaqi-fc12ca5c3d.json')
firebase_admin.initialize_app(cred)

api = Api(app)

# @app.route('/')
# def index():
#     return "<h1>Welcome to the Collectify API</h1>"

# @app.route('/users')
# def get_users():
#     users = User.query.all()
#     return [user.to_dict() for user in users]

# # CHECK SESSION
# @app.get('/check_session')
# def check_session():
#     user = User.query.get(session.get('user_id'))
#     print(f'check session {session.get("user_id")}')
#     if user:
#         return user.to_dict(rules=['-password']), 200
#     else:
#         return {"message": "No user logged in"}, 401

# # LOGIN
# @app.post('/login')
# def login():
#     data = request.json

#     user = User.query.filter(User.name == data.get('name')).first()

#     if user and bcrypt.check_password_hash(user.password, data.get('password')):
#         session["user_id"] = user.id
#         print("success")
#         return user.to_dict(rules=['-password']), 200
#     else:
#         return { "error": "Invalid username or password" }, 401

def check_firebase_connection():
    try:
        user = auth.get_user_by_email('test@test.com')
        print('Successfully fetched user data:', user)
    except Exception as e:
        print('Failed to fetch user data:', e)

check_firebase_connection()


class Index(Resource):
    def get(self):
        return {'message': 'Welcome to the Collectify API'}

class Users(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('username', required=True, help="Username cannot be blank!")
    parser.add_argument('first_name', required=True, help="First name cannot be blank!")
    parser.add_argument('last_name', required=True, help="Last name cannot be blank!")
    parser.add_argument('email', required=True, help="Email cannot be blank!")
    parser.add_argument('password', required=True, help="Password cannot be blank!")

    def get(self):
        users = User.query.all()
        return {'users': [user.to_dict() for user in users]}

    def post(self):
        data = Users.parser.parse_args()
        if User.query.filter_by(username=data['username']).first():
            return {'message': 'A user with that username already exists'}, 400
        if User.query.filter_by(email=data['email']).first():
            return {'message': 'A user with that email already exists'}, 400
        
        # Create a new user in Firebase
        firebase_user = auth.create_user(
            email=data['email'],
            email_verified=False,
            password=data['password'],
            display_name=data['username'],
            disabled=False
        )
        
        # Create a new user in database
        hashed_password = bcrypt.generate_password_hash(data['password']).decode('utf-8')
        user = User(
            username=data['username'], 
            first_name=data['first_name'], 
            last_name=data['last_name'], 
            email=data['email'], 
            password=hashed_password
        )
        db.session.add(user)
        db.session.commit()
        return user.to_dict(), 201

class UsersByID(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('username', required=False)
    parser.add_argument('first_name', required=False)
    parser.add_argument('last_name', required=False)
    parser.add_argument('email', required=False)
    parser.add_argument('password', required=False)

    def get(self, user_id):
        user = User.query.get(user_id)
        if user:
            return user.to_dict()
        else:
            return {'message': 'User not found'}, 404



    # def put(self, user_id):
    #     data = UserResource.parser.parse_args()
    #     user = User.query.get(user_id)
    #     if user:
    #         user.username = data['username']
    #         user.first_name = data['first_name']
    #         user.last_name = data['last_name']
    #         user.email = data['email']
    #         db.session.commit()
    #         return user.to_dict()
    #     else:
    #         return {'message': 'User not found'}, 404
    
    def patch(self, user_id):
        data = UsersByID.parser.parse_args()
        user = User.query.get(user_id)
        if user:                                                    
            if 'username' in data:
                user.username = data['username']
            if 'first_name' in data:
                user.first_name = data['first_name']
            if 'last_name' in data:
                user.last_name = data['last_name']
            if 'email' in data:
                user.email = data['email']
            if 'password' in data:
                hashed_password = bcrypt.generate_password_hash(data['password']).decode('utf-8')
                user.password = hashed_password
            # if 'current_password' in data:
            #     if bcrypt.check_password_hash(user.password, data['current_password']):  //// too verify current password before changing
            #         if 'password' in data:
            #             hashed_password = bcrypt.generate_password_hash(data['password']).decode('utf-8')
            #             user.password = hashed_password
            #     else:
            #         return {'message': 'Current password is incorrect'}, 401
            db.session.commit()
            return user.to_dict()
        else:
            return {'message': 'User not found'}, 404

    def delete(self, user_id):
        user = User.query.get(user_id)
        if user:
            db.session.delete(user)
            db.session.commit()
            return {'message': 'User deleted'}
        else:
            return {'message': 'User not found'}, 404

class UserCollections(Resource):
    def get(self, user_id):
        user = User.query.get(user_id)
        if user:
            collections = [collection.to_dict() for collection in user.collections]
            return collections
        else:
            return {'message': 'User not found'}, 404

class Collections(Resource):

    def get(self):
        collections = Collection.query.options(joinedload(Collection.comments), joinedload(Collection.likes), joinedload(Collection.user)).all()
        collections_data = []
        for collection in collections:
            collection_data = collection.to_dict()
            collection_data['user'] = collection.user.to_dict()  # Include user data
            collection_data['comments'] = [comment.to_dict() for comment in collection.comments]  # Include comments
            collection_data['likes_count'] = len(collection.likes)  # Include likes count
            collections_data.append(collection_data)
        return collections_data
    
    def post(self):
        data = request.get_json()
        collection = Collection(title=data['title'], 
                                description=data['description'], 
                                image_url=data['image_url'], 
                                user_id=data['user_id'])
        db.session.add(collection)
        db.session.commit()
        return collection.to_dict(), 201
    
class CollectionByID(Resource):
    
    def get(self, collection_id):
        collection = Collection.query.options(joinedload(Collection.comments), joinedload(Collection.likes)).get(collection_id)
        if collection is None:
            return {'message': 'Collection not found'}, 404

        collection_data = collection.to_dict()
        collection_data['user'] = collection.user.to_dict()  # Include user data
        collection_data['comments'] = [comment.to_dict() for comment in collection.comments]  # Include comments
        collection_data['likes_count'] = len(collection.likes)  # Include likes count
        # collection_data['likes'] = [like.to_dict() for like in collection.likes]  # Include likes

        return collection_data, 200

    def patch(self, collection_id):
        data = request.get_json()
        collection = Collection.query.get(collection_id)
        if collection:
            collection.title = data.get('title', collection.title)
            collection.description = data.get('description', collection.description)
            collection.image_url = data.get('image_url', collection.image_url)
            db.session.commit()
            return collection.to_dict()
        else:
            return {'message': 'Collection not found'}, 404

    def delete(self, collection_id):
        collection = Collection.query.get(collection_id)
        if collection:
            db.session.delete(collection)
            db.session.commit()
            return {'message': 'Collection deleted'}
        else:
            return {'message': 'Collection not found'}, 404
        
class CommentResource(Resource):

    def get(self):
        comments = Comment.query.all()
        return {'comments': [comment.to_dict() for comment in comments]}

    def post(self):
        data = request.get_json()
        comment = Comment(text=data['text'])
        db.session.add(comment)
        db.session.commit()
        return comment.to_dict(), 201
            
api.add_resource(Index, '/')
api.add_resource(Users, '/users')
api.add_resource(UsersByID, '/users/<int:user_id>')
api.add_resource(UserCollections, '/users/<int:user_id>/collections')
api.add_resource(Collections, '/collections')
api.add_resource(CollectionByID, '/collections/<int:collection_id>')
api.add_resource(CommentResource, '/comments')   

if __name__ == '__main__':
    app.run(port=5565, debug=True)