ThinkingSphinx::Index.define :post, with: :real_time do
  indexes body

  has topic_id, type: :integer
  has user_id, type: :integer
  has remote_created_at, type: :timestamp
  has remote_id, type: :integer

  set_property enable_star: 1
  set_property min_infix_len: 3
  set_property dict: :keywords
end
