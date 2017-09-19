module Fastlane
  module Actions
    class UploadSymbolsToAppseeAction < Action
      def self.run(params)
        if lane_context[SharedValues::DSYM_PATHS].nil?
          UI.user_error! "DSYM_PATHS is nil. Please run the `download_dsyms` action before running this action"
        end

        zip_path = lane_context[SharedValues::DSYM_PATHS].first

        # rubocop:disable Style/FormatStringToken
        sh "curl 'https://api.appsee.com/crashes/upload-symbols?APIKey=#{params[:api_key]}' --write-out %{http_code} --verbose --output /dev/null -F dsym=@'#{zip_path}'"
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload symbols to Appsee"
      end

      def self.details
        "This action allows you to upload symbol files to Appsee. This action requires the `download_dsyms` action to have been called before it, and the `SharedValues::DSYM_PATHS` value to exist."
      end

      def self.authors
        ["nathanshox"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :api_key,
                                       env_name: "FL_UPLOAD_SYMBOLS_TO_APPSEE_API_KEY", # The name of the environment variable
                                       description: "API key for UploadSymbolsToAppseeAction", # a short description of this parameter
                                       verify_block: proc do |value|
                                         UI.user_error!("No API key for UploadSymbolsToAppseeAction given, pass using `api_key: 'key'`") unless value and !value.empty?
                                       end)
        ]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
