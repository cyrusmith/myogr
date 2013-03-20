#require "iconv"
require "mysql2"
module Forum
  module Connectable

    CP1251 = "cp1251"
    UTF8 = "utf-8"

    Connect = Mysql2::Client.new(:host => "ogromno.com",
                                 :username => "lopinopulos",
                                 :password => "lopinopulos",
                                 :database => "mika_007_forum_test",
                                 :encoding => "cp1251")

    def process_query (query)
      result = Connect.query(query)
    end
  end
end
