class MicropostShareRelationship < ApplicationRecord
    belongs_to :user,      class_name: User.name
    belongs_to :micropost, class_name: Micropost.name
    validates :user_id,      presence: true
    validates :micropost_id, presence: true
end
