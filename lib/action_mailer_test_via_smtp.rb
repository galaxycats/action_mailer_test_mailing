module ActionMailer
  class Base
    @@test_recipient = false
    cattr_accessor :test_recipient
    
    def perform_delivery_test_via_smtp(mail)
      mail.body = %Q{
------------------------------- Test-Mail (#{Rails.env}) -------------------------------
Original-Recipient: #{mail.to.join(", ")}
CC: #{mail.cc ? mail.cc.join(", ") : "no CC"}
BCC: #{mail.bcc ? mail.bcc.join(", ") : "no BCC"}
----------------------------------------------------------------------------------
#{mail.body}  
      }
      mail.to = self.class.test_recipient
      mail.cc = nil
      mail.bcc = nil
      perform_delivery_smtp(mail)
    end
    
  end
end
