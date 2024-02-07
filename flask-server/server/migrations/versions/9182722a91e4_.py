"""empty message

Revision ID: 9182722a91e4
Revises: 3f678a4d09b6
Create Date: 2024-02-05 14:37:17.530951

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '9182722a91e4'
down_revision = '3f678a4d09b6'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('users', sa.Column('user_bio', sa.Text(), nullable=True))
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('users', 'user_bio')
    # ### end Alembic commands ###