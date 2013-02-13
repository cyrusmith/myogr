module Billing
  class Base < ActiveResource::Base
    self.site = Settings.billing.url
    #self.user = Settings.billing.login
    #self.password = Settings.billing.password
    #self.ssl_options = {:cert         => OpenSSL::X509::Certificate.new(File.open(pem_file))
    #                          :key          => OpenSSL::PKey::RSA.new(File.open(pem_file)),
    #                          :ca_path      => "/path/to/OpenSSL/formatted/CA_Certs",
    #                          :verify_mode  => OpenSSL::SSL::VERIFY_PEER}
  end
end