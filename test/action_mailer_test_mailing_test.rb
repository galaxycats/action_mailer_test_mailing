require "test_helper"

class ActionMailerTestMailingTest < ActiveSupport::TestCase
  
  test "should add content to body" do
    Notifier.deliveries = []
    Rails.expects(:env).returns(:test)
    assert Notifier.deliver_plain_text_email
    assert_equal 1, Notifier.deliveries.size
    assert_match /Original-Recipient: test@galaxycats.com/, Notifier.deliveries.first.body
  end
  
  test "should add content to every body of multipart email" do
    Notifier.deliveries = []
    Rails.expects(:env).at_least_once.returns(:test)
    assert Notifier.deliver_multipart_email
    assert_equal 1, Notifier.deliveries.size
    mail = Notifier.deliveries.first
    assert Notifier.deliveries.first.parts.size > 0
    Notifier.deliveries.first.each_part do |part|
      if part.content_type == "text/html"
        assert_match /Original-Recipient: test@galaxycats.com<br>/, part.body
      else
        assert_match /Original-Recipient: test@galaxycats.com/, part.body
      end
    end
  end
  
end