require "action_mailer_test_mailing/header_renderer/base"

module ActionMailerTestMailing
  module HeaderRenderer
    class Standard < Base
      
      def test_mail_header
        %Q{------------------------------- Test-Mail (#{Rails.env}) -------------------------------
Original-Recipient: #{mail.to.join(", ")}
CC: #{mail.cc ? mail.cc.join(", ") : "no CC"}
BCC: #{mail.bcc ? mail.bcc.join(", ") : "no BCC"}
----------------------------------------------------------------------------------
}
      end

      def test_mail_header_html
        test_mail_header.gsub("\n", "<br>")
      end
      
    end
  end
end
