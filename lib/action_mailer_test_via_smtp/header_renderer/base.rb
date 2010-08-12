module ActionMailerTestViaSmtp
  module HeaderRenderer
    class Base
      
      attr_reader :mail
      
      def initialize(mail)
        @mail = mail
      end
      
    end
  end
end