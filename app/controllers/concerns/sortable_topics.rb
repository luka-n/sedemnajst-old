module SortableTopics
  extend ActiveSupport::Concern

  private

  def map_sort_key(key, default)
    map = {
      "id"                               => "id",
      "id_desc"                          => "id DESC",
      "title"                            => "title",
      "title_desc"                       => "title DESC",
      "user_id"                          => "user_id",
      "user_id_desc"                     => "user_id DESC",
      "remote_id"                        => "remote_id",
      "remote_id_desc"                   => "remote_id DESC",
      "posts_count"                      => "posts_count",
      "posts_count_desc"                 => "posts_count DESC",
      "last_post_remote_created_at"      => "last_post_remote_created_at",
      "last_post_remote_created_at_desc" => "last_post_remote_created_at DESC",
      "last_post_remote_id"              => "last_post_remote_id",
      "last_post_remote_id_desc"         => "last_post_remote_id DESC",
      "remote_created_at"                => "remote_created_at",
      "remote_created_at_desc"           => "remote_created_at DESC"
    }
    map[key] || map[default]
  end
end
