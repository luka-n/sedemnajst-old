module SortableUsers
  extend ActiveSupport::Concern

  private

  def map_sort_key(key, default)
    map = {id: "id",
           id_desc: "id DESC",
           name: "name",
           name_desc: "name DESC",
           remote_id: "remote_id",
           remote_id_desc: "remote_id DESC",
           posts_count: "posts_count",
           posts_count_desc: "posts_count DESC",
           topics_count: "topics_count",
           topics_count_desc: "topics_count DESC"}
    map[key.try(:to_sym)] || map[default.to_sym]
  end
end
