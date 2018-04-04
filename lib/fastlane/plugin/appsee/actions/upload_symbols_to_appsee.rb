module Fastlane
  module Actions
    class UploadSymbolsToAppseeAction < Action
      def self.run(params)
        
        dsym_paths = []
        dsym_paths << params[:dsym_path] if params[:dsym_path]
        dsym_paths += Actions.lane_context[SharedValues::DSYM_PATHS] if Actions.lane_context[SharedValues::DSYM_PATHS]
        zip_path = dsym_paths.first

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
                                       end),
          FastlaneCore::ConfigItem.new(key: :dsym_path,
                                       env_name: "FL_UPLOAD_SYMBOLS_TO_APPSEE_DSYM_PATH", # The name of the environment variable
                                       description: "Path to the DSYM file or zip to upload", # a short description of this parameter
                                       verify_block: proc do |value|
                                         UI.user_error!("Couldn't find file at path '#{File.expand_path(value)}'") unless File.exist?(value)
                                         UI.user_error!("Symbolication file needs to be dSYM or zip") unless value.end_with?(".zip", ".dSYM")
                                       end)
        ]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
