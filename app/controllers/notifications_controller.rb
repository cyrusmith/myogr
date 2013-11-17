class NotificationsController < AuthorizedController
  def index
    @user = User.find params[:user_id]
    @notifications = @user.notifications
    @notifications = @notifications.select { |n| not (n.read?) } if params[:unread].present?
    respond_to do |format|
      format.html
      format.js
    end
  end

  def read
    #TODO проверить, можно ли отменить прочтение из под другого пользователя
    notification = Notification.find params[:id]
    respond_to do |format|
      if notification.read
        format.json { render status: :ok, json: notification }
      else
        format.json {render status: :unprocessable_entity}
      end
    end
  end

end
