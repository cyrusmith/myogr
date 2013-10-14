module Forum
  module Bankroll

    def deposit(amount, description='')
      ::User.transaction do
        add_to_log_sql = "INSERT INTO `ibf_money_log`(`from_member`, `to_member`, `date`, `sum`, `descrip`)
                          VALUES (0, #{self.id}, #{DateTime.now.to_i}, #{amount}, '#{description}')"
        ::User.connection.execute(add_to_log_sql)
        change_balance(amount, self.id)
      end
    end

    def withdraw(amount, to=1, description='')
      ::User.transaction do
        add_to_log_sql = "INSERT INTO `ibf_money_log`(`from_member`, `to_member`, `date`, `sum`, `descrip`)
                          VALUES (#{self.id}, #{to}, #{DateTime.now.to_i}, #{amount}, '#{description}')"
        ::User.connection.execute(add_to_log_sql)
        change_balance(-amount, self.id)
        change_balance(amount, to)
      end
    end

    def change_balance(amount, user_id)
      self.cash = self.cash + amount
      self.save
      self.cash
    end

  end
end