require 'aws-sdk'
require 'httparty'
require 'pry'

module Elec2tion
  module Aws
    class Ec2
      def initialize(options = {})
        @security_group_name = options[:"security-group-name"]
        @instance_id = options[:"instance-id"]
        @region = options[:region] ||= region

        @client = ::Aws::EC2::Client.new(region: @region)
      end

      def compare
        instance_id == first_instance_id(security_group_id(security_group_name))
      end

      private

      def security_group_name
        return @security_group_name if @security_group_name

        Timeout.timeout(2) do
          response = HTTParty.get('http://169.254.169.254/latest/meta-data/security-groups')

          raise Elec2tion::Aws::Ec2::Security_Group_Name::Missing if response.code != '200'

          @security_group_name = response.body
        end
      rescue Timeout::Error
        puts 'Unable to determine security group of instance.'
        exit 1
      rescue Elec2tion::Aws::Ec2::Security_Group_Name::Missing
        puts 'Unable to determine security group of instance.'
        exit 1
      end

      def instance_id
        return @instance_id if @instance_id

        Timeout.timeout(2) do
          response = HTTParty.get('http://169.254.169.254/latest/meta-data/instance_id')

          raise Elec2tion::Aws::Ec2::Instance_Id::Missing if response.code != '200'

          @instance_id_id = response.body
        end
      rescue Timeout::Error
        puts 'Unable to determine instance id.'
        exit 1
      rescue Elec2tion::Aws::Ec2::Instance_Id::Missing
        puts 'Unable to determine instance id.'
        exit 1
      end

      def security_group_id(security_group_name)
        filters = [
          { name: 'group-name', values: [security_group_name] }
        ]

        @client.describe_security_groups(filters: filters).security_groups.first.group_id
      end

      def first_instance_id(security_group_id)
        filters = [
          { name: 'instance.group-id', values: [security_group_id] }
        ]

        @client.describe_instances(filters: filters).reservations.first.instances.first.instance_id
      end

      def region
        return @region if @region

        Timeout.timeout(2) do
          response = HTTParty.get('http://169.254.169.254/latest/meta-data/placement/availability-zone')

          raise Elec2tion::Aws::Ec2::Region::Missing if response.code != '200'

          availability_zone = response.body
          @region = availability_zone[0...-1]
        end
      rescue Timeout::Error
        puts 'Unable to determine region of instance.'
        exit 1
      rescue Elec2tion::Aws::Ec2::Region::Missing
        puts 'Unable to determine region of instance.'
        exit 1
      end
    end
  end
end
