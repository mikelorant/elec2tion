module Elec2tion
  # Elec2tion::Base
  class Base
    def initialize(options)
      @options = options
    end

    def version
      puts Elec2tion::VERSION
    end

    def elect
      result = Elec2tion::Aws::Ec2.new(@options).compare
      puts format result
      exit result[:result]
    end

    private

    def format(result)
      <<-END.gsub /^\s+/, ''
        Security Group Name: #{result[:security_group_name]}
        Security Group ID: #{result[:security_group_id]}
        Instance ID: #{result[:instance_id]}
        Elected ID: #{result[:elected_id]}
        #{result[:result] ? 'Instance is elected.' : 'Instance is not elected.'}
      END
    end
  end
end
