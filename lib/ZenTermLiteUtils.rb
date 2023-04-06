# Copyright (c) 2023 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

require 'securerandom'
require 'erb'

# Config ZenTermLite
class ZenTermLiteUtils
  def initialize(username, key_name, **hosts)
    @username = username
    @key_name = key_name
    @template = ERB.new(File.read("#{File.dirname(__FILE__)}/Sessions.zss.erb"))
    @projects = hosts.keys
    @hosts = []
    @host_ips = {}
    @folder_uuids = {}
    @folder_uuids_str = ''
    @host_uuids = {}
    @config_hosts = hosts
  end

  def folder_uuids
    @projects.each do |p|
      @folder_uuids.merge!(p => SecureRandom.uuid.upcase)
    end
  end

  def folder_uuids_str
    @folder_uuids_str = @folder_uuids.values.join(' ')
  end

  def host_ips
    @projects.each do |p|
      @config_hosts[p].each do |key, val|
        @hosts << key
        @host_ips.merge!(key => val)
      end
    end
  end

  def host_uuids
    @hosts.each do |h|
      @host_uuids.merge!(h => SecureRandom.uuid.upcase)
    end
  end

  def config
    folder_uuids
    folder_uuids_str
    host_ips
    host_uuids
    File.open("#{File.dirname(__FILE__)}/../out/Sessions.zss", 'w') { |f| f.puts @template.result(binding) }
    puts 'ZenTermLite config finish!'
  end
end
