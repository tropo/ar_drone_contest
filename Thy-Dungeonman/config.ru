#!/usr/bin/env rackup

begin
  require ::File.expand_path('.bundle/environment', __FILE__)
rescue LoadError
  require 'rubygems'
  require 'bundler'
  Bundler.setup
end

require './thy-dungeonman'

use Rack::Static, :urls => ["/css", "/images", "/js", "/audio", "/favicon.ico"], :root => "public"

run ThyDungeonman::Application