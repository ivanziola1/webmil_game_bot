require 'dotenv/load'
require 'awesome_print'
require 'telegram/bot'
require 'sequel'
require 'rufus-scheduler'
require 'sucker_punch'
require 'sucker_punch/async_syntax'
require 'rest-client'
require 'oj'
require_relative 'db/connection'
# require_relative 'schedule'


Dir[File.dirname(__FILE__) + '/app/**/*.rb'].each {|file| require file }

TelegramListener.call
