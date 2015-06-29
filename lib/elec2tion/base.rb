module Elec2tion
  class Base
    def initialize(options)
      @options = options
    end

    def version
      puts Elec2tion::VERSION
    end

    def elect
      result = Elec2tion::Aws::Ec2.new(@options).compare
      puts result ? 'Instance is elected.' : 'Instance is not elected.'
      exit result
    end
  end
end