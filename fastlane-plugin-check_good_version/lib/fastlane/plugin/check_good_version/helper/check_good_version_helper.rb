module Fastlane
  module Helper
    class CheckGoodVersionHelper
      # class methods that you define here become available in your action
      # as `Helper::CheckGoodVersionHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the check_good_version plugin helper!")
      end
    end
  end
end
