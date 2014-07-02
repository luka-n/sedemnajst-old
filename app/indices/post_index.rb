ThinkingSphinx::Index.define :post, with: :active_record do
  indexes body
  has remote_created_at
  set_property enable_star: 1
  set_property min_infix_len: 3
end
