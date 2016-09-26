module Fastlane
  module Helper
    class GoodifyInfoPlistHelper
      # class methods that you define here become available in your action
      # as `Helper::GoodifyInfoPlistHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the goodify_info_plist plugin helper!")
      end
    end
  end
end
