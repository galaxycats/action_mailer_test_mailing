$:.reject! { |e| e.include? 'TextMate' }

ENV["RAILS_ENV"] = "test"

require "rubygems"
require "bundler"
Bundler.setup

require 'test/unit'
require "active_support"
require "active_support/test_case"
require "active_support/core_ext"
require "action_mailer"
require "action_mailer_test_via_smtp"
require "mocha"

ActionMailer::Base.delivery_method = :test_via_test
ActionMailer::Base.test_recipient = "tester@galaxycats.com"
ActionMailer::Base.template_root = "test/templates"

class Rails; end

class Notifier < ActionMailer::Base
  
  def plain_text_email
    recipients ["test@galaxycats.com"]
  end
  
  def multipart_email
    recipients ["test@galaxycats.com"]
  end
  
end