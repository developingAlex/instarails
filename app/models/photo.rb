class Photo < ApplicationRecord
  include ImageUploader::Attachment.new(:image) # adds an `image` virtual attribute
  belongs_to :user
  has_and_belongs_to_many :likers, class_name: 'User', join_table: :likes

  def liked_by?(user)
    likers.exists?(user.id)
  end

  def toggle_liked_by(user)
      if liked_by?(user)
          likers.destroy(user.id)
      else
          likers << user
      end
  end
end
