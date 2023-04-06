# Copyright (c) 2023 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

require 'yaml'

# Config
class Config
  def config
    YAML.load_file("#{File.dirname(__FILE__)}/../config/config.yml")
  end
end
