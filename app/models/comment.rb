class Comment < ApplicationRecord
  belongs_to :photo
  belongs_to :user
  belongs_to :parent_comment, class_name: 'Comment'
end
