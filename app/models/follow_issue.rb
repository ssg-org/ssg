class FollowIssue < Follow
  belongs_to  :follow_issue, :foreign_key => :follow_ref_id, :class_name => 'Issue'
end