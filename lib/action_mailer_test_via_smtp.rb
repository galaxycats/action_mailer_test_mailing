require "action_mailer_test_via_smtp/header_renderer/standard"

module ActionMailer
  class Base
    @@test_recipient = false
    cattr_accessor :test_recipient
    
    @@test_mail_header_renderer = ActionMailerTestViaSmtp::HeaderRenderer::Standard
    cattr_accessor :test_mail_header_renderer
    
    def test_mail_header_renderer(mail)
      @test_mail_header_renderer ||= self.class.test_mail_header_renderer.new(mail)
    end
    
    def generate_test_mail_header(mail)
      test_mail_header_renderer(mail).test_mail_header
    end
    
    def generate_test_mail_header_html(mail)
      test_mail_header_renderer(mail).test_mail_header_html
    end
    
    [:sendmail, :smtp, :test].each do |meth|
      define_method "perform_delivery_test_via_#{meth}" do |mail|
        if mail.multipart?
          mail.each_part do |part|
            if part.content_type == "text/html"
              part.body = generate_test_mail_header_html(mail) + part.body
            else
              part.body = generate_test_mail_header(mail) + part.body
            end
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

module ActionMailerTestViaSmtp
end