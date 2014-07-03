ThinkingSphinx::Index.define :post, with: :real_time do
  indexes body
  has remote_created_at, type: :timestamp
  set_property enable_star: 1
  set_property min_infix_len: 3
  set_property dict: :keywords
end
