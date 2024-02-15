from flask import Flask, make_response, jsonify, request, session
from flask_restful import Resource, Api, reqparse
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_cors import CORS
from dotenv import dotenv_values
from models import db, User, Collection, Comment, Like, Tag, Forum, Post, CommentOnPost, MarketPlaceItem, Followers, Bookmark
from werkzeug.security import generate_password_hash, check_password_hash
from werkzeug.datastructures import FileStorage
from flask_bcrypt import Bcrypt
from sqlalchemy.orm.exc import NoResultFound
from sqlalchemy.orm import joinedload, contains_eager
from flask_bcrypt import Bcrypt
import firebase_admin
from firebase_admin import credentials, auth, storage
from firebase_admin.auth import EmailAlreadyExistsError
import datetime
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

# Add 'user_image' to the parser
class Users(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('username', required=True, help="Username cannot be blank!")
    parser.add_argument('first_name', required=True, help="First name cannot be blank!")
    parser.add_argument('last_name', required=True, help="Last name cannot be blank!")
    parser.add_argument('email', required=True, help="Email cannot be blank!")
    parser.add_argument('password', required=True, help="Password cannot be blank!")
    parser.add_argument('user_image', type=FileStorage, location='files') 

    def get(self):
        self.parser.add_argument('user_image', type=FileStorage, location='files')
        users = User.query.all()
        return {'users': [user.to_dict() for user in users]}

    def post(self):
        data = Users.parser.parse_args()
        if User.query.filter_by(username=data['username']).first():
            return {'message': 'A user with that username already exists'}, 400
        if User.query.filter_by(email=data['email']).first():
            return {'message': 'A user with that email already exists'}, 400
        
         # Upload the user image to Firebase Storage
        user_image = data['user_image']
        if user_image:
            blob = storage.bucket().blob(user_image.filename)
            blob.upload_from_string(user_image.read(), content_type=user_image.content_type)
            image_url = blob.generate_signed_url(datetime.timedelta(seconds=3600), method='GET')
        else:
            image_url = None

        try:
            # Create a new user in Firebase
            firebase_user = auth.create_user(
                email=data['email'],
                email_verified=False,
                password=data['password'],
                display_name=data['username'],
                disabled=False
            )
        except EmailAlreadyExistsError:
            return {'message': 'A user with that email already exists in Firebase'}, 400
        except Exception as e:
            print('Failed to create user:', e)
            return {'message': 'Failed to create user'}, 500

        # Create a new user in database
        hashed_password = bcrypt.generate_password_hash(data['password']).decode('utf-8')
        user = User(
            username=data['username'], 
            first_name=data['first_name'], 
            last_name=data['last_name'], 
            email=data['email'], 
            password=hashed_password,
            uid=firebase_user.uid,
            user_image=image_url,
        )
        db.session.add(user)
        db.session.commit()
        return user.to_dict(), 201
    
class UserByUid(Resource):

    def get(self, user_uid):
        user = User.query.filter_by(uid=user_uid).first()
        if user:
            return user.to_dict()
        else:
            return {'message': 'User not found'}, 404
        
    def patch(self, user_uid):
        data = UserByUid.parser.parse_args()
        user = User.query.filter_by(uid=user_uid).first()
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
        
    def delete(self, user_uid):
        user = User.query.filter_by(uid=user_uid).first()
        if user:
            db.session.delete(user)
            db.session.commit()
            return {'message': 'User deleted'}
        else:
            return {'message': 'User not found'}, 404

class UsersByUsername(Resource):

    def get(self, username):
        user = User.query.filter_by(username=username).first()
        if user:
            return user.to_dict()
        else:
            return {'message': 'User not found'}, 404
        
    def patch(self, username):
        data = UserByUid.parser.parse_args()
        user = User.query.filter_by(username=username).first()
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
        
class UserCollectionsByUsername(Resource):

    def get(self, username):
        user = User.query.filter_by(username=username).first()
        if user is None:
            return {'message': 'User not found'}, 404

        collections = Collection.query.options(
            joinedload(Collection.comments).joinedload(Comment.user),
            joinedload(Collection.likes)
        ).filter_by(user_id=user.id).all()

        collections_data = []
        for collection in collections:
            collection_data = collection.to_dict()
            collection_data['user'] = user.to_dict()  # Include user data
            collection_data['comments'] = [{'comment': comment.to_dict(), 'user': comment.user.to_dict()} for comment in collection.comments]  # Include comments and user data
            collection_data['likes_count'] = len(collection.likes)  # Include likes count
            collections_data.append(collection_data)

        return collections_data, 200

# class UsersByID(Resource):
#     parser = reqparse.RequestParser()
#     parser.add_argument('username', required=False)
#     parser.add_argument('first_name', required=False)
#     parser.add_argument('last_name', required=False)
#     parser.add_argument('email', required=False)
#     parser.add_argument('password', required=False)

#     def get(self, user_id):
#         user = User.query.get(user_id)
#         if user:
#             return user.to_dict()
#         else:
#             return {'message': 'User not found'}, 404



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
    
    # def patch(self, user_id):
    #     data = UsersByID.parser.parse_args()
    #     user = User.query.get(user_id)
    #     if user:                                                    
    #         if 'username' in data:
    #             user.username = data['username']
    #         if 'first_name' in data:
    #             user.first_name = data['first_name']
    #         if 'last_name' in data:
    #             user.last_name = data['last_name']
    #         if 'email' in data:
    #             user.email = data['email']
    #         if 'password' in data:
    #             hashed_password = bcrypt.generate_password_hash(data['password']).decode('utf-8')
    #             user.password = hashed_password
            # if 'current_password' in data:
            #     if bcrypt.check_password_hash(user.password, data['current_password']):  //// too verify current password before changing
            #         if 'password' in data:
            #             hashed_password = bcrypt.generate_password_hash(data['password']).decode('utf-8')
            #             user.password = hashed_password
            #     else:
            #         return {'message': 'Current password is incorrect'}, 401
            # db.session.commit()
    #         return user.to_dict()
    #     else:
    #         return {'message': 'User not found'}, 404

    # def delete(self, user_id):
    #     user = User.query.get(user_id)
    #     if user:
    #         db.session.delete(user)
    #         db.session.commit()
    #         return {'message': 'User deleted'}
    #     else:
    #         return {'message': 'User not found'}, 404

# class UserCollections(Resource):
#     def get(self, user_id):
#         user = User.query.get(user_id)
#         if user:
#             collections = [collection.to_dict() for collection in user.collections]
#             return collections
#         else:
#             return {'message': 'User not found'}, 404
        
class UserCollectionsWithUid(Resource):
    def get(self, user_uid):
        user = User.query.filter_by(uid=user_uid).first()
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
            collection_data['comments'] = [{'comment': comment.to_dict(), 'user': comment.user.to_dict()} for comment in collection.comments]  # Include comments and user data
            collection_data['likes_count'] = len(collection.likes)  # Include likes count
            collections_data.append(collection_data)
        return collections_data
    
    def post(self):
        data = request.get_json()
        image_url = data['image_url']

        # Check if the image URL is from Firebase Storage
        if 'firebasestorage.googleapis.com' in image_url:
            # Get the blob from Firebase Storage
            blob = storage.bucket().blob(image_url)

            # Check if the blob exists
            if not blob.exists():
                return {'message': 'Image not found'}, 404

        collection = Collection(title=data['title'], 
                                description=data['description'], 
                                image_url=image_url, 
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
    
class LikeResource(Resource):
    def get(self):
        likes = Like.query.all()
        return {'likes': [like.to_dict() for like in likes]}
        

    def post(self):
        try:
            data = request.get_json()
            new_like = Like(
                user_id=data['user_id'],
                collection_id=data['collection_id']
            )
            db.session.add(new_like)
            db.session.commit()
            return {'message': 'Like added successfully'}, 201
        except Exception as e:
            return {'message': str(e)}, 400

class LikeByID(Resource):
    def get(self, like_id):
        like = Like.query.get(like_id)
        if like:
            return like.to_dict()
        else:
            return {'message': 'Like not found'}, 404
        
    def patch(self, like_id):
        data = request.get_json()
        like = Like.query.get(like_id)
        if like:
            like.user_id = data.get('user_id', like.user_id)
            like.collection_id = data.get('collection_id', like.collection_id)
            db.session.commit()
            return like.to_dict()
        else:
            return {'message': 'Like not found'}, 404

    def delete(self, like_id):
        like = Like.query.get(like_id)
        if like:
            db.session.delete(like)
            db.session.commit()
            return {'message': 'Like deleted'}
        else:
            return {'message': 'Like not found'}, 404
        
class TagResource(Resource):
    def get(self):
        tags = Tag.query.all()
        return {'tags': [tag.to_dict() for tag in tags]}
    
    def post(self):
        data = request.get_json()
        tag = Tag()
        db.session.add(tag)
        db.session.commit()
        return tag.to_dict(), 201

class ForumResource(Resource):
    def get(self):
        Forums = Forum.query.all()
        return {'Forums': [forum.to_dict() for forum in Forums]}

    def post(self):
        data = request.get_json()
        forum = Forum()
        db.session.add(forum)
        db.session.commit()
        return forum.to_dict(), 201

class PostResource(Resource):
    def get(self):
        Posts = Post.query.all()
        return {'Posts': [post.to_dict() for post in Posts]}

    def post(self):
        data = request.get_json()
        post = Post()
        db.session.add(post)
        db.session.commit()
        return post.to_dict(), 201

class CommentOnPostResource(Resource):
    def get(self):
        CommentsOnPosts = CommentOnPost.query.all()
        return {'CommentsOnPosts': [comment_on_post.to_dict() for comment_on_post in CommentsOnPosts]}

    def post(self):
        data = request.get_json()
        comment_on_post = CommentOnPost()
        db.session.add(comment_on_post)
        db.session.commit()
        return comment_on_post.to_dict(), 201

class MarketPlaceItemResource(Resource):
    def get(self):
        MarketPlaceItems = MarketPlaceItem.query.all()
        return {'MarketPlaceItems': [market_place_item.to_dict() for market_place_item in MarketPlaceItems]}

    def post(self):
        data = request.get_json()
        market_place_item = MarketPlaceItem()
        db.session.add(market_place_item)
        db.session.commit()
        return market_place_item.to_dict(), 201

class FollowersResource(Resource):
    def get(self):
        Followers = Followers.query.all()
        return {'Followers': [follower.to_dict() for follower in Followers]}

    def post(self):
        data = request.get_json()
        follower = Followers()
        db.session.add(follower)
        db.session.commit()
        return follower.to_dict(), 201

class BookmarkResource(Resource):
    def get(self):
        Bookmarks = Bookmark.query.all()
        return {'Bookmarks': [bookmark.to_dict() for bookmark in Bookmarks]}

    def post(self):
        data = request.get_json()
        bookmark = Bookmark()
        db.session.add(bookmark)
        db.session.commit()
        return bookmark.to_dict(), 201

            
api.add_resource(Index, '/')
api.add_resource(Users, '/users')
# api.add_resource(UsersByID, '/users/<int:user_id>')
api.add_resource(UserByUid, '/users/<string:user_uid>')
# api.add_resource(UserCollections, '/users/<int:user_id>/collections')
api.add_resource(UserCollectionsWithUid, '/users/<string:user_uid>/collections')
api.add_resource(UsersByUsername, '/users/info/<string:username>')
api.add_resource(Collections, '/collections')
api.add_resource(UserCollectionsByUsername, '/users/info/<string:username>/collections')
api.add_resource(CollectionByID, '/collections/<int:collection_id>')
api.add_resource(CommentResource, '/comments')   
api.add_resource(LikeResource, '/likes')
api.add_resource(LikeByID, '/likes/<int:like_id>')
api.add_resource(TagResource, '/tags')
api.add_resource(ForumResource, '/forums')
api.add_resource(PostResource, '/posts')
api.add_resource(CommentOnPostResource, '/comments_on_posts')
api.add_resource(MarketPlaceItemResource, '/market_place_items')
api.add_resource(FollowersResource, '/followers')
api.add_resource(BookmarkResource, '/bookmarks')

if __name__ == '__main__':
    app.run(port=5565, debug=True)