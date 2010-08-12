module ActionMailer
  class Base
    @@test_recipient = false
    cattr_accessor :test_recipient
    
    def generate_test_mail_header(mail)
      %Q{------------------------------- Test-Mail (#{Rails.env}) -------------------------------
Original-Recipient: #{mail.to.join(", ")}
CC: #{mail.cc ? mail.cc.join(", ") : "no CC"}
BCC: #{mail.bcc ? mail.bcc.join(", ") : "no BCC"}
----------------------------------------------------------------------------------
}
    end
    
    [:sendmail, :smtp, :test].each do |meth|
      define_method "perform_delivery_test_via_#{meth}" do |mail|
        if mail.multipart?
          test_mail_header = generate_test_mail_header(mail)
          mail.each_part do |part|
            part.body = test_mail_header + part.body
          end
        else
          mail.body = generate_test_mail_header(mail) + mail.body
        end
        mail.to = self.class.test_recipient
        mail.cc = nil
        mail.bcc = nil
        send("perform_delivery_#{meth}", mail)
      end
    end
  end
end
