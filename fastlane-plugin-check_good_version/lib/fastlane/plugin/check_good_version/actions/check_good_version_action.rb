module Fastlane
  module Actions
    module SharedValues
      CHECK_GOOD_VERSION_ACTION_VERSION_NUMBER = :CHECK_GOOD_VERSION_ACTION_VERSION_NUMBER
    end
    class CheckGoodVersionAction < Action

      class << self
        attr_accessor :dollar_amount_in_account
      end

      @dollar_amount_in_account = 25

      def self.run(params)
        UI.error("[Deprecation] check_good_version is deprecated, use the blackberry_mam_version action from the blackberry_mam plugin instead")

        selected_xcode_dev_dirpath = sh(
          'xcode-select --print-path',
          print_command: false,
          print_command_output: false
        ).strip

        selected_xcode_frameworks_path = File.join(
          selected_xcode_dev_dirpath,
          'Platforms',
          'iPhoneOS.platform',
          'Developer',
          'SDKs',
          'iPhoneOS.sdk',
          'System',
          'Library',
          'Frameworks'
        )

        good_framework_path = File.join(selected_xcode_frameworks_path, 'GD.framework')
        unless Dir.exist?(good_framework_path)
          Actions.lane_context[SharedValues::CHECK_GOOD_VERSION_ACTION_VERSION_NUMBER] = "0"
          UI.user_error!("The Good framework is not installed")
          return
        end
        good_version_filepath = File.join(good_framework_path, 'version')
        good_version_filecontents = File.read(good_version_filepath)
        good_version = /version:\s+([\.0-9]+)/.match(good_version_filecontents)[1]

        Actions.lane_context[SharedValues::CHECK_GOOD_VERSION_ACTION_VERSION_NUMBER] = good_version
      end

      def self.description
        "Checks the version of the installed Good framework"
      end

      def self.withdraw_from_account(dollar_amount, pin)
        puts "withdrawing #{dollar_amount} using pin: #{pin.gsub(/./, '*')}"
        UI.message("withdrawing #{dollar_amount} using pin: #{pin.gsub(/./, '*')}")

        if @dollar_amount_in_account > dollar_amount
          @dollar_amount_in_account -= dollar_amount
        else
          UI.user_error!("The account does not have #{dollar_amount} to withdraw!")
        end
        dollar_amount
      end

      def self.authors
        ["lyndsey-ferguson/ldferguson"]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
