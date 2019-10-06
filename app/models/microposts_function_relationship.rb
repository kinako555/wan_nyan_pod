class MicropostsFunctionRelationship < ApplicationRecord
    # 定数
    module FunctionTypeName # 機能名
        SHARE =    'share'.freeze    # シェア
        FAVORITE = 'favorite'.freeze # お気に入り
    end
    
    belongs_to :shared, class_name: "User"
    validates :checker_id,    presence: true
    validates :checked_id,    presence: true
    validates :function_type, presence: true
end
