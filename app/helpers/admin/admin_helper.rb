module Admin::AdminHelper
  include ApplicationHelper

  def fast_action_context_is(context_hash = {})
    @fast_action_context = context_hash
  end
end
