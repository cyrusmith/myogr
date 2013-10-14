module Forum
  module Bankroll

    def deposit(amount, description='')
      ::User.transaction do
        add_to_log_sql = "INSERT INTO `ibf_money_log`(`from_member`, `to_member`, `date`, `sum`, `descrip`)
                          VALUES (0, #{self.id}, #{DateTime.now.to_i}, #{amount}, '#{description}')"
        ::User.connection.execute(add_to_log_sql)
        change_balance(amount, self.id)
        balance
      end
    end

    def withdraw(amount, to=1, description='')
      ::User.transaction do
        add_to_log_sql = "INSERT INTO `ibf_money_log`(`from_member`, `to_member`, `date`, `sum`, `descrip`)
                          VALUES (#{self.id}, #{to}, #{DateTime.now.to_i}, #{amount}, '#{description}')"
        ::User.connection.execute(add_to_log_sql)
        change_balance(-amount, self.id)
        change_balance(amount, to)
        balance
      end
    end

    def balance
      get_balance_value_sql = "SELECT `cash` FROM `ibf_members` WHERE `id`=#{self.id}"
      ::User.connection.select_all(get_balance_value_sql).first['cash']
    end

    def change_balance(amount, user_id)
      get_balance_value_sql = "SELECT `cash` FROM `ibf_members` WHERE `id`=#{user_id}"
      balance_value = ::User.connection.select_all(get_balance_value_sql).first()
      add_balance_value_sql = "UPDATE `ibf_members` SET  `cash` =  #{amount + balance_value['cash']} WHERE  `ibf_members`.`id` =#{user_id};"
      ::User.connection.execute(add_balance_value_sql)
    end

  end
end