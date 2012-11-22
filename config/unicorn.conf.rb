worker_processes 4

working_directory "/opt/ogromno/ogromno" # available in 0.94.0+

# listen "/tmp/.sock", :backlog => 64
listen 8080, :tcp_nopush => true

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

pid "/opt/ogromno/ogromno/tmp/pids/unicorn.pid"
stderr_path "/opt/ogromno/ogromno/log/unicorn.stderr.log"
stdout_path "/opt/ogromno/ogromno/log/unicorn.stdout.log"

# combine Ruby 2.0.0dev or REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
  end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

end
