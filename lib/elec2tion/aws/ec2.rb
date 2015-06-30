require 'aws-sdk'
require 'httparty'
require 'pry'

module Elec2tion
  module Aws
    # Elec2tion::Aws::Ec2
    class Ec2
      SECURITY_GROUPS   = 'http://169.254.169.254/latest/meta-data/security-groups'
      INSTANCE_ID       = 'http://169.254.169.254/latest/meta-data/instance_id'
      AVAILABILITY_ZONE = 'http://169.254.169.254/latest/meta-data/placement/availability-zone'

      def initialize(options = {})
        @security_group_name = options[:"security-group-name"] || security_group_name
        @instance_id = options[:"instance-id"] || instance_id
        @region = options[:region] || region

        @client = ::Aws::EC2::Client.new(region: @region)
      end

      def compare
        security_group_id = security_group_id(@security_group_name)
        elected_id = oldest_instance_id(security_group_id)
        result = @instance_id == elected_id

        {
          result:              result,
          elected_id:          elected_id,
          security_group_name: @security_group_name,
          security_group_id:   security_group_id,
          instance_id:         @instance_id
        }
      end

      private

      def security_group_name
        query SECURITY_GROUPS
      end

      def instance_id
        query INSTANCE_ID
      end

      def region
        availability_zone = query AVAILABILITY_ZONE
        availability_zone_to_region(availability_zone)
      end

      def security_group_id(security_group_name)
        filters = [
          { name: 'group-name', values: [security_group_name] }
        ]

        @client.describe_security_groups(filters: filters).security_groups.first.group_id
      end

      def oldest_instance_id(security_group_id)
        filters = [
          { name: 'instance.group-id', values: [security_group_id] }
        ]

        @client.describe_instances(filters: filters).reservations.select { |r|
          r.instances.first.state.name == 'running'
        }.sort_by { |r|
          r.instances.first.launch_time
        }.first.instances.first.instance_id
      end

      def query(url)
        Timeout.timeout(2) do
          response = HTTParty.get(url)

          fail Response::Code::Error if response.code != '200'

          response.body
        end
      rescue Timeout::Error, Response::Code::Error
        option = convert_symbols metadata_name url
        puts "Unable to determine #{option}."
        exit 1
      end

      def availability_zone_to_region(availability_zone)
        availability_zone[0...-1]
      end

      def metadata_name(url)
        url.split('/')[-1]
      end

      def convert_symbols(string)
        string.gsub(/-|_/, ' ')
      end
    end
  end
end
