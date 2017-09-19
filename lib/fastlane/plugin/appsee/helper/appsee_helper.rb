module Fastlane
  module Helper
    class AppseeHelper
      # class methods that you define here become available in your action
      # as `Helper::AppseeHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the appsee plugin helper!")
      end
    end
  end
end
