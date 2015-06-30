require 'require_all'

require_all 'lib'

module Elec2tion
  class << self
    attr_accessor :configure, :elected, :options
    alias_method :elected?, :elected
  end

  def self.configure(options = {})
    self.options = options

    self
  end

  def self.elected?
    self.options ||= {}

    Elec2tion::Aws::Ec2.new(self.options).elected?[:result]
  end
end
