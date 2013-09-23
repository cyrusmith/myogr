module Forum
  class Bankroll

    def deposit
    end

    def self.withdraw(amount, from, to=1, description='')
      ::User.transaction do
        add_to_log_sql = "INSERT INTO `ibf_money_log`(`from_member`, `to_member`, `date`, `sum`, `descrip`)
                          VALUES (#{from}, #{to}, #{DateTime.now.to_i}, #{amount}, '#{description}')"
        ::User.connection.execute(add_to_log_sql)
        change_balance(-amount, from)
        change_balance(amount, to)
      end
    end

    def balance

    end

    def self.change_balance(amount, user_id)
      get_balance_value_sql = "SELECT `cash` FROM `ibf_members` WHERE `id`=#{user_id}"
      balance_value = ::User.connection.select_all(get_balance_value_sql).first()
      add_balance_value_sql = "UPDATE `ibf_members` SET  `cash` =  #{amount + balance_value['cash']} WHERE  `ibf_members`.`id` =#{user_id};"
      ::User.connection.execute(add_balance_value_sql)
    end

  end
end