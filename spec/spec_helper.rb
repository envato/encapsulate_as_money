# encoding: utf-8
require 'encapsulate_as_money'
require 'rspec/given'
require 'integration_helper' if ENV['APPRAISAL_INITIALIZED'] || ENV['TRAVIS']

RSpec.configure do |config|
  config.color = true
end
