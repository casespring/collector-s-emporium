"""empty message

Revision ID: 3f678a4d09b6
Revises: 1604a95a26b5
Create Date: 2024-01-31 00:13:06.545257

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '3f678a4d09b6'
down_revision = '1604a95a26b5'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('notifications')
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('notifications',
    sa.Column('id', sa.INTEGER(), nullable=False),
    sa.Column('type', sa.VARCHAR(), nullable=True),
    sa.Column('created_at', sa.DATETIME(), nullable=True),
    sa.Column('user_id', sa.INTEGER(), nullable=True),
    sa.Column('related_user_id', sa.INTEGER(), nullable=True),
    sa.Column('related_collection_id', sa.INTEGER(), nullable=True),
    sa.Column('related_post_id', sa.INTEGER(), nullable=True),
    sa.Column('related_market_place_item_id', sa.INTEGER(), nullable=True),
    sa.ForeignKeyConstraint(['related_collection_id'], ['collections.id'], ),
    sa.ForeignKeyConstraint(['related_market_place_item_id'], ['market_place_items.id'], ),
    sa.ForeignKeyConstraint(['related_post_id'], ['posts.id'], ),
    sa.ForeignKeyConstraint(['related_user_id'], ['users.id'], ),
    sa.ForeignKeyConstraint(['user_id'], ['users.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    # ### end Alembic commands ###
