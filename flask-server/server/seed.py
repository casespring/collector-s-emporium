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
            created_at=fake.date_time_this_decade(),
            uid=fake.text()
        )
        user_list.append(user)

    db.session.add_all(user_list)
    db.session.commit()

def seed_collections(num_collections=10):
    collection_list = []
    image_urls = ["https://www.boredpanda.com/blog/wp-content/uploads/2020/11/interesting-collections-6-5faa8f95a3cdf__700.jpg",
                  "https://www.brandeis.edu/library/archives/images/home/home-3.jpg", "https://static.tuoitrenews.vn/ttnew/r/2021/04/28/isjvusodfvkevkeri6cbrj22ny-1619576951.jpg",
                  "https://i2-prod.dailystar.co.uk/incoming/article19459388.ece/ALTERNATES/s1227b/0_httpscdnimagesdailystarcoukdynamic122photos286000900x738841286",
                  "https://atchuup.com/wp-content/uploads/2014/11/crazy-collections-hot-sauce.jpg",
                  "https://img.buzzfeed.com/buzzfeed-static/static/2017-09/12/14/asset/buzzfeed-prod-fastlane-01/sub-buzz-25004-1505242758-6.jpg?downsize=1600%3A%2A&output-quality=auto&output-format=auto",
                  "https://cdn.homeaddict.io/wp-content/uploads/2022/05/a3fc0997-f81f-4d8d-b0e6-6d68e6d94a6e-545x438.jpeg",
                  "https://images2.minutemediacdn.com/image/upload/c_fill,w_1440,ar_16:9,f_auto,q_auto,g_auto/shape/cover/sport/pr-6-23b21dbf15d8b8071a0d68ca3f2ae689.jpg",
                  "https://img.buzzfeed.com/buzzfeed-static/static/2017-09/12/14/asset/buzzfeed-prod-fastlane-02/sub-buzz-22040-1505241544-5.jpg?downsize=1600%3A%2A&output-quality=auto&output-format=auto",
                  "https://cdn.apartmenttherapy.info/image/upload/v1680191961/at/style/2023-04/hilton-carter-target-collection-2023/hilton-carter-target-collection-2023.jpg",
                  "https://i.etsystatic.com/22211647/r/il/bd899e/3877978083/il_570xN.3877978083_6ytt.jpg",]
    
    random.shuffle(image_urls)

    for i in range(num_collections):
        collection = Collection(
            title=fake.sentence(),
            description=fake.text(),
            image_url=image_urls.pop(),
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
