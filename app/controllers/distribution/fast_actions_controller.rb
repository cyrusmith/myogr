#coding: utf-8
module Distribution
  class FastActionsController < ApplicationController
    authorize_resource class: User
    def deposit
      if params[:user_id] && params[:amount] && params[:point_id]
        user = User.find(params[:user_id])
        description = "Пополнение счета пользователя #{user.id}/#{user.display_name} из Центра раздач №#{params[:point_id]}"
        new_balance = user.deposit(params[:amount].to_i, description)
        respond_to do |format|
          format.js {render 'js_messages/message',
                    locals: {message: "Баланс успешно пополнен. Текущий баланс пользователя - #{new_balance} руб.",
                             message_type: 'success'}}
        end
      else
        render head(:bad_request)
      end
    end
  end
end