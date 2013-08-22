collection @package_sets
attributes :user_id, :items_attributes, :collector_id, :collection_date, :distribution_method, :document_number
glue(:user) do
  attributes :display_name => :username
end

child(:items) do
  attributes :item_id, :title, :organizer, :organizer_id, :is_next_time_pickup, :state_on_creation, :is_user_participate, :user_id, :location, :recieved_from
end