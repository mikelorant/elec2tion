require 'thor'

module Elec2tion
  # Elec2tion::Commandline
  class Commandline < Thor
    package_name 'Elec2tion'
    map ['-v', '--version'] => :version

    desc 'version', 'Print the version and exit.'

    def version
      Elec2tion::Base.new(options).version
    end

    desc 'elect', 'Elects a security group leader.'

    method_option :quiet,                 type: :boolean, aliases: '-q', desc: 'Quiet output.'
    method_option :"security-group-name", type: :string,  aliases: '-s', desc: 'Optional security group name.'
    method_option :"instance-id",         type: :string,  aliases: '-i', desc: 'Optional instance id.'
    method_option :region,                type: :string,  aliases: '-r', desc: 'Optional region.'

    def elect
      Elec2tion::Base.new(options).elect
    end
  end
end
