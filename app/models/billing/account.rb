module Billing
  class Account < Base
    #include MoneyRails::ActiveRecord::Monetizable
    #monetize :balance_cents
  end
end