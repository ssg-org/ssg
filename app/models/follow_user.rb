class FollowUser < Follow
  belongs_to  :follow_user, :foreign_key => :follow_ref_id, :class_name => 'User'
end