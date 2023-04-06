# Copyright (c) 2023 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# 主机名前面把项目名加上, 否则会导致配置文件分类匹配不到
# 比如 A 项目, 主机名为 A-xxx
# 主机配置信息在 config/config.rb 里面

require 'json'
require 'yaml'
require_relative 'lib/config'
require_relative 'lib/gcp'
require_relative 'lib/ZenTermLiteUtils'

username = 'kevin'
key_name = 'kevin'

desc 'default task'
task default: [:push]

desc 'git push'
task :push do
  sh 'git add .'
  sh 'git commit -m "update."'
  sh 'git push -u origin main'
end

desc 'generate ssh config'
task :run do
  c = Config.new.config
  puts c
  z = ZenTermLiteUtils.new(username = c[:username], key_name = c[:key_name], **host = c[:hosts])
  z.config
end

desc 'generate yml config'
task :yaml do
  g = GCP.new
  cf = { username: username, key_name: key_name, hosts: g.project_hosts }
  File.open("#{File.dirname(__FILE__)}/config/config.yml", 'w') { |f| f.write(cf.to_yaml) }
  # rescue StandardError => e
  #   puts e.message
  #   retry
end
