from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import MetaData, ForeignKey
from sqlalchemy.ext.declarative import declared_attr
from sqlalchemy.orm import validates
from sqlalchemy.ext.associationproxy import association_proxy
from sqlalchemy_serializer import SerializerMixin
from sqlalchemy.sql import func

# Create a metadata instance
# Definitions of tables and associated schema constructs
metadata = MetaData()

# A Flask SQLAlchemy extension
db = SQLAlchemy(metadata=metadata)

class User(db.Model, SerializerMixin):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, unique=True , nullable=False)
    first_name = db.Column(db.String(30), nullable=False)
    last_name = db.Column(db.String(30), nullable=False)
    email = db.Column(db.String, unique=True, nullable=False)
    password = db.Column(db.String, nullable=False)
    user_image = db.Column(db.String)
    created_at = db.Column(db.DateTime(timezone=True), default=func.now())
    updated_at = db.Column(db.DateTime(timezone=True), onupdate=func.now())

    # relationships
    # notifications = db.relationship("Notification", back_populates="user", foreign_keys="Notification.user_id")
    # related_notifications = db.relationship("Notification", back_populates="related_user", foreign_keys="Notification.related_user_id")

    # relationships back_populates
    collections = db.relationship("Collection", back_populates="user", cascade="all, delete-orphan")
    comments = db.relationship("Comment", back_populates="user", cascade="all, delete-orphan")
    likes = db.relationship("Like", back_populates="user", cascade="all, delete-orphan")
    forums = db.relationship("Forum", back_populates="user", cascade="all, delete-orphan")
    posts = db.relationship("Post", back_populates="user", cascade="all, delete-orphan")
    comments_on_posts = db.relationship("CommentOnPost", back_populates="user", cascade="all, delete-orphan")
    market_place_items = db.relationship("MarketPlaceItem", back_populates="user", cascade="all, delete-orphan")
    followers = db.relationship("Followers", foreign_keys="Followers.follower_user_id", back_populates="follower", cascade="all, delete-orphan")
    following = db.relationship("Followers", foreign_keys="Followers.following_user_id", back_populates="following", cascade="all, delete-orphan")
    bookmarks = db.relationship("Bookmark", back_populates="user", cascade="all, delete-orphan")

    # serialize_rules
    serialize_rules = ["-collections.user", 
                       "-comments.user", 
                       "-likes.user", 
                       "-forums.user", 
                       "-posts.user", 
                       "-comments_on_posts.user", 
                       "-market_place_items.user", 
                       "-followers.follower", 
                       "-following.following",
                       "-bookmarks.user"]

    def __repr__(self):
        return f"<User {self.id}: {self.username}, {self.first_name}, {self.last_name}, {self.user_image}, {self.created_at}>"
    
class Collection(db.Model, SerializerMixin):
    __tablename__ = 'collections'

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String)
    description = db.Column(db.Text)
    image_url = db.Column(db.String)    
    created_at = db.Column(db.DateTime(timezone=True), default=func.now())
    updated_at = db.Column(db.DateTime(timezone=True), onupdate=func.now())

    # relationships
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    # relationships back_populates
    user = db.relationship("User", back_populates="collections")
    comments = db.relationship("Comment", back_populates="collection", cascade="all, delete-orphan")
    likes = db.relationship("Like", back_populates="collection", cascade="all, delete-orphan")
    bookmarks = db.relationship("Bookmark", back_populates="collection", cascade="all, delete-orphan")
    # notifications = db.relationship("Notification", back_populates="collection", cascade="all, delete-orphan")

    # serialize_rules
    serialize_rules = ["-user.collections", "-comments.collection", "-likes.collection", "-bookmarks.collection"]

    def __repr__(self):
        return f"<Collection {self.id}: {self.title}, {self.description}, {self.user_id}, {self.created_at}>"
    
class Comment(db.Model, SerializerMixin):
    __tablename__ = 'comments'

    id = db.Column(db.Integer, primary_key=True)
    text = db.Column(db.Text)
    created_at = db.Column(db.DateTime(timezone=True), default=func.now())
    updated_at = db.Column(db.DateTime(timezone=True), onupdate=func.now())

    # relationships
    user_id = db.Column(db.Integer, db.ForeignKey('users.id')) 
    collection_id = db.Column(db.Integer, db.ForeignKey('collections.id')) 

    # relationships back_populates
    user = db.relationship("User", back_populates="comments")
    collection = db.relationship("Collection", back_populates="comments")

    # serialize_rules
    serialize_rules = ["-user.comments", "-collection.comments"]

    def __repr__(self):
        return f"<Comment {self.id}: {self.text}, {self.user_id}, {self.collection_id}, {self.created_at}>"

class Like(db.Model, SerializerMixin):
    __tablename__ = 'likes'

    id = db.Column(db.Integer, primary_key=True)
    created_at = db.Column(db.DateTime(timezone=True), default=func.now())

    # relationships
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    collection_id = db.Column(db.Integer, db.ForeignKey('collections.id'))

    # relationships back_populates
    user = db.relationship("User", back_populates="likes")
    collection = db.relationship("Collection", back_populates="likes")

    # serialize_rules
    serialize_rules = ["-user.likes", "-collection.likes"]

    def __repr__(self):
        return f"<Like {self.id}: {self.user_id}, {self.collection_id}, {self.created_at}>"

class Tag(db.Model, SerializerMixin):
    __tablename__ = 'tags'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String)

    def __repr__(self):
        return f"<Tag {self.id}: {self.name}>"    
                        
class Forum(db.Model, SerializerMixin):
    __tablename__ = 'forums'

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String)
    description = db.Column(db.Text)
    created_at = db.Column(db.DateTime(timezone=True), default=func.now())
    updated_at = db.Column(db.DateTime(timezone=True), onupdate=func.now())

    # relationships
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))

    # relationships back_populates
    user = db.relationship("User", back_populates="forums")
    posts = db.relationship("Post", back_populates="forum", cascade="all, delete-orphan")

    # serialize_rules
    serialize_rules = ["-user.forums", "-posts.forum"]

    def __repr__(self):
        return f"<Forum {self.id}: {self.title}, {self.description}, {self.user_id}, {self.created_at}>"

class Post(db.Model, SerializerMixin):
    __tablename__ = 'posts'

    id = db.Column(db.Integer, primary_key=True)
    text = db.Column(db.Text)
    created_at = db.Column(db.DateTime(timezone=True), default=func.now())
    updated_at = db.Column(db.DateTime(timezone=True), onupdate=func.now())

    # relationships
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    forum_id = db.Column(db.Integer, db.ForeignKey('forums.id'))

    # relationships back_populates
    user = db.relationship("User", back_populates="posts")
    forum = db.relationship("Forum", back_populates="posts")
    comments_on_posts = db.relationship("CommentOnPost", back_populates="post", cascade="all, delete-orphan")
    bookmarks = db.relationship("Bookmark", back_populates="post", cascade="all, delete-orphan")
    # notification = db.relationship("Notification", back_populates="post", cascade="all, delete-orphan")
    # notifications = db.relationship("Notification", back_populates="related_post", foreign_keys="Notification.related_post_id")

    # serialize_rules
    serialize_rules = ["-user.posts", "-forum.posts", "-comments_on_posts.post", "-bookmarks.post"]

    def __repr__(self):
        return f"<Post {self.id}: {self.text}, {self.user_id}, {self.forum_id}, {self.created_at}>"
    
class CommentOnPost(db.Model, SerializerMixin):
    __tablename__ = 'comments_on_posts'

    id = db.Column(db.Integer, primary_key=True)
    text = db.Column(db.Text)
    created_at = db.Column(db.DateTime(timezone=True), default=func.now())
    updated_at = db.Column(db.DateTime(timezone=True), onupdate=func.now())

    # relationships
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    post_id = db.Column(db.Integer, db.ForeignKey('posts.id'))

    # relationships back_populates
    user = db.relationship("User", back_populates="comments_on_posts")
    post = db.relationship("Post", back_populates="comments_on_posts")

    # serialize_rules
    serialize_rules = ["-user.comments_on_posts", "-post.comments_on_posts"]

    def __repr__(self):
        return f"<CommentOnPost {self.id}: {self.text}, {self.user_id}, {self.post_id}, {self.created_at}>"
    
class MarketPlaceItem(db.Model, SerializerMixin):
    __tablename__ = 'market_place_items'

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String)
    description = db.Column(db.Text)
    price = db.Column(db.Float)
    image_url = db.Column(db.String)
    created_at = db.Column(db.DateTime(timezone=True), default=func.now())
    updated_at = db.Column(db.DateTime(timezone=True), onupdate=func.now())

    # relationships
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))

    # relationships back_populates
    user = db.relationship("User", back_populates="market_place_items")
    bookmarks = db.relationship("Bookmark", back_populates="market_place_items", cascade="all, delete-orphan")
    # notifications = db.relationship("Notification", back_populates="related_marketplace_item", cascade="all, delete-orphan")

    # serialize_rules
    serialize_rules = ["-user.market_place_items", "-bookmarks.market_place_items"]

    def __repr__(self):
        return f"<MarketPlaceItem {self.id}: {self.title}, {self.description}, {self.price}, {self.user_id}, {self.created_at}>"
    
class Followers(db.Model, SerializerMixin):
    __tablename__ = 'followers'

    id = db.Column(db.Integer, primary_key=True)

    # relationships
    follower_user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    following_user_id = db.Column(db.Integer, db.ForeignKey('users.id'))

    # relationships back_populates
    follower = db.relationship("User", foreign_keys=[follower_user_id])
    following = db.relationship("User", foreign_keys=[following_user_id])

    # serialize_rules
    serialize_rules = ["-follower.followers", "-following.followers"]

    def __repr__(self):
        return f"<Followers {self.id}: {self.follower_user_id}, {self.following_user_id}>"

class Bookmark(db.Model, SerializerMixin):
    __tablename__ = 'bookmarks'

    id = db.Column(db.Integer, primary_key=True)

    # relationships
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    collection_id = db.Column(db.Integer, db.ForeignKey('collections.id'))
    post_id = db.Column(db.Integer, db.ForeignKey('posts.id'))
    market_place_items_id = db.Column(db.Integer, db.ForeignKey('market_place_items.id'))

    # relationships back_populates
    user = db.relationship("User", back_populates="bookmarks")
    collection = db.relationship("Collection", back_populates="bookmarks")
    post = db.relationship("Post", back_populates="bookmarks")
    market_place_items = db.relationship("MarketPlaceItem", back_populates="bookmarks")

    # serialize_rules
    serialize_rules = ["-user.bookmarks", "-collection.bookmarks", "-post.bookmarks", "-market_place_item.bookmarks"]

    def __repr__(self):
        return f"<Bookmark {self.id}: {self.user_id}, {self.collection_id}, {self.post_id}, {self.market_place_items_id}>"
    
# class Notification(db.Model, SerializerMixin):
#     __tablename__ = 'notifications'

#     id = db.Column(db.Integer, primary_key=True)
#     type = db.Column(db.String)
#     created_at = db.Column(db.DateTime(timezone=True), default=func.now())

#     # relationships
#     user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
#     related_user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
#     related_collection_id = db.Column(db.Integer, db.ForeignKey('collections.id'))
#     related_post_id = db.Column(db.Integer, db.ForeignKey('posts.id'))
#     related_market_place_item_id = db.Column(db.Integer, db.ForeignKey('market_place_items.id'))

#     # relationships back_populates
#     user = db.relationship("User", back_populates="notifications", foreign_keys=[user_id])
#     related_user = db.relationship("User", back_populates="related_notifications", foreign_keys=[related_user_id])
#     collection = db.relationship("Collection", back_populates="notification")
#     related_collection = db.relationship("Collection", back_populates='notifications', foreign_keys=[related_collection_id])
#     post = db.relationship("Post", back_populates="notification", foreign_keys=[related_post_id])
#     related_post = db.relationship("Post", back_populates='notifications', foreign_keys=[related_post_id])
#     related_marketplace_item = db.relationship("MarketPlaceItem", back_populates='notifications', foreign_keys=[related_market_place_item_id])

#     # serialize_rules
#     serialize_rules = ["-user.notifications", 
#                        "-related_user.related_notifications", 
#                        "-related_collection.notifications", 
#                        "-related_post.notifications", 
#                        "-related_market_place_item.notifications"]
    
#     def __repr__(self):
#         return f"<Notification {self.id}: {self.type}, {self.user_id}, {self.created_at}>"
    


    
