from app import app
from models import db, User, Collection, Comment, Like, Tag, Forum, Post, CommentOnPost, MarketPlaceItem, Followers, Bookmark

if __name__ == '__main__':
    with app.app_context():
        import ipdb; ipdb.set_trace()