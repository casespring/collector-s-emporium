from app import app
from models import db, User, Collection, Comment, Like, Tag, Forum, Post, CommentOnPost, MarketPlaceItem, Followers, Bookmark
from random import choice, randint, choice as rc
import json
from datetime import datetime
import random
from faker import Faker
from sqlalchemy.sql import func 
from flask_bcrypt import Bcrypt

# Using random and faker to libaries to generate info 
fake = Faker()

def seed_users(bcrypt, num_users=30):
    user_list = []

    for i in range(num_users):
        user = User(
            username=fake.user_name(),
            first_name=fake.first_name(),
            last_name=fake.last_name(),
            email=fake.email(),
            password=bcrypt.generate_password_hash(str(i)).decode('utf-8'),
            user_image=fake.image_url(),
            user_bio=fake.text(),
            created_at=fake.date_time_this_decade()
        )
        user_list.append(user)

    db.session.add_all(user_list)
    db.session.commit()

def seed_collections(num_collections=50):
    collection_list = []

    for i in range(num_collections):
        collection = Collection(
            title=fake.sentence(),
            description=fake.text(),
            image_url=fake.image_url(),
            user_id=randint(1, 10),
            created_at=fake.date_time_this_decade()
        )
        collection_list.append(collection)

    db.session.add_all(collection_list)
    db.session.commit()

def seed_comments(num_comments=100):
    user_ids = [user.id for user in User.query.all()]
    collection_ids = [collection.id for collection in Collection.query.all()]
    comment_list = []

    for i in range(num_comments):
        comment = Comment(
            text=fake.sentence(),
            user_id=random.choice(user_ids),
            collection_id=random.choice(collection_ids),
            created_at=fake.date_time_this_decade(),
            updated_at=fake.date_time_this_decade()
        )
        comment_list.append(comment)

    db.session.add_all(comment_list)
    db.session.commit()

def seed_likes(num_likes=100):
    user_ids = [user.id for user in User.query.all()]
    collection_ids = [collection.id for collection in Collection.query.all()]
    like_list = []

    for i in range(num_likes):
        like = Like(
            user_id=random.choice(user_ids),
            collection_id=random.choice(collection_ids),
            created_at=fake.date_time_this_decade()
        )
        like_list.append(like)

    db.session.add_all(like_list)
    db.session.commit()

def seed_forums(num_forums=30):
    user_ids = [user.id for user in User.query.all()]
    forum_list = []

    for i in range(num_forums):
        forum = Forum(
            title=fake.sentence(),
            description=fake.text(),
            user_id=random.choice(user_ids),
            created_at=fake.date_time_this_decade(),
            updated_at=fake.date_time_this_decade()
        )
        forum_list.append(forum)

    db.session.add_all(forum_list)
    db.session.commit()

def seed_posts(num_posts=100):
    user_ids = [user.id for user in User.query.all()]
    forum_ids = [forum.id for forum in Forum.query.all()]
    post_list = []

    for i in range(num_posts):
        post = Post(
            text=fake.text(),
            user_id=random.choice(user_ids),
            forum_id=random.choice(forum_ids),
            created_at=fake.date_time_this_decade(),
            updated_at=fake.date_time_this_decade()
        )
        post_list.append(post)

    db.session.add_all(post_list)
    db.session.commit()

def seed_comments_on_posts(num_comments=200):
    user_ids = [user.id for user in User.query.all()]
    post_ids = [post.id for post in Post.query.all()]
    comment_list = []

    for i in range(num_comments):
        comment = CommentOnPost(
            text=fake.sentence(),
            user_id=random.choice(user_ids),
            post_id=random.choice(post_ids),
            created_at=fake.date_time_this_decade(),
            updated_at=fake.date_time_this_decade()
        )
        comment_list.append(comment)

    db.session.add_all(comment_list)
    db.session.commit()

def seed_market_place_items(num_items=50):
    user_ids = [user.id for user in User.query.all()]
    item_list = []

    for i in range(num_items):
        item = MarketPlaceItem(
            title=fake.sentence(),
            description=fake.text(),
            price=fake.random_number(digits=2, fix_len=True),
            image_url=fake.image_url(),
            user_id=random.choice(user_ids),
            created_at=fake.date_time_this_decade(),
            updated_at=fake.date_time_this_decade()
        )
        item_list.append(item)

    db.session.add_all(item_list)
    db.session.commit()

def seed_tags(num_tags=50):
    tag_list = []

    for i in range(num_tags):
        tag = Tag(
            name=fake.word()
        )
        tag_list.append(tag)

    db.session.add_all(tag_list)
    db.session.commit()

def seed_followers(num_follows=100):
    user_ids = [user.id for user in User.query.all()]
    follow_list = []

    for i in range(num_follows):
        follower = Followers(
            follower_user_id=random.choice(user_ids),
            following_user_id=random.choice(user_ids)
        )
        follow_list.append(follower)

    db.session.add_all(follow_list)
    db.session.commit()

def seed_bookmarks(num_bookmarks=100):
    user_ids = [user.id for user in User.query.all()]
    collection_ids = [collection.id for collection in Collection.query.all()]
    post_ids = [post.id for post in Post.query.all()]
    market_place_item_ids = [item.id for item in MarketPlaceItem.query.all()]
    bookmark_list = []

    for i in range(num_bookmarks):
        bookmark = Bookmark(
            user_id=random.choice(user_ids),
            collection_id=random.choice(collection_ids),
            post_id=random.choice(post_ids),
            market_place_items_id=random.choice(market_place_item_ids)
        )
        bookmark_list.append(bookmark)

    db.session.add_all(bookmark_list)
    db.session.commit()

if __name__ == "__main__":
    with app.app_context():
        bcrypt = Bcrypt(app)
#     with app.app_context():         for db.json file
#         with open("db.json") as f:
#             data = json.load(f)

        User.query.delete()
        Collection.query.delete()
        Comment.query.delete()
        Like.query.delete()
        Forum.query.delete()
        Post.query.delete()
        CommentOnPost.query.delete()
        MarketPlaceItem.query.delete()
        Tag.query.delete()
        Followers.query.delete()
        Bookmark.query.delete()

        seed_users(bcrypt)
        seed_collections()
        seed_comments()
        seed_likes()
        seed_forums()
        seed_posts()
        seed_comments_on_posts()
        seed_market_place_items()
        seed_tags()
        seed_followers()
        seed_bookmarks()
