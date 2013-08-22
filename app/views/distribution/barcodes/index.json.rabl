object @barcode

attributes :barcode_string, :creator, :owner, :value, :package_item_id, :created_at, :updated_at
child :package_item do
  attributes :id, :item_id, :title, :organizer, :organizer_id, :is_next_time_pickup, :state, :state_on_creation, :is_user_participate, :user_id
  glue(:user) do
    attributes :display_name => :username
  end
end
