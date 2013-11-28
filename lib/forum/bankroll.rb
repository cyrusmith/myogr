module Forum
  module Bankroll

    def deposit(amount, description='', group='other')
      ::User.transaction do
        add_to_log_sql = "INSERT INTO `ibf_money_log`(`from_member`, `to_member`, `date`, `sum`, `descrip`, `group_name`)
                          VALUES (0, #{self.id}, #{DateTime.now.to_i}, #{amount}, '#{description}', '#{group}')"
        ::User.connection.execute(add_to_log_sql)
        change_balance(amount)
      end
    end

    def withdraw(amount, to=1, description='', group='other')
      ::User.transaction do
        add_to_log_sql = "INSERT INTO `ibf_money_log`(`from_member`, `to_member`, `date`, `sum`, `descrip`, `group_name`)
                          VALUES (#{self.id}, #{to}, #{DateTime.now.to_i}, #{amount}, '#{description}', '#{group}')"
        ::User.connection.execute(add_to_log_sql)
        User.find(to).change_balance(amount)
        change_balance(-amount)
      end
    end

    def change_balance(amount)
      self.cash = self.cash + amount
      self.save
      self.cash
    end

  end
end