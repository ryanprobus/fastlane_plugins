require 'pry-byebug'
module Fastlane
  module Actions
    class SetupFragileTestsForRescanAction < Action
      require 'nokogiri'
      require 'xcodeproj'

      def self.run(params)
        report_file = File.open(params[:report_filepath]) { |f| Nokogiri::XML(f) }
        UI.user_error!("Malformed XML test report file given") if report_file.errors.length > 0
        UI.user_error!("Valid XML file is not an Xcode test report") if report_file.xpath('//testsuites').length.zero?

        # remove all testcases that failed from the report file
        # so that our subsequent steps here can just focus on finding
        # passing testcases to suppress
        report_file.xpath('//failure').each do |failure_element|
          failure_element.parent.remove
        end

        scheme = xcscheme(params)

        report_file.xpath('//testsuites').each do |testsuite|
          buildable_name = testsuite['name'].to_s

          test_action = scheme.test_action
          testable = test_action.testables.find { |t| t.buildable_references[0].buildable_name == buildable_name }

          report_file.xpath('//testcase').each do |testcase|
            skipped_test = Xcodeproj::XCScheme::TestAction::TestableReference::SkippedTest.new
            skipped_test.identifier = "#{testcase['classname']}/#{testcase['name']}"
            testable.add_skipped_test(skipped_test)
            testcase.remove
          end
        end
        scheme.save!
      end

      def self.xcscheme(params)
        project_path = params[:project_path]
        scheme_name = params[:scheme]

        scheme_filepath = File.join(Xcodeproj::XCScheme.shared_data_dir(project_path), "#{scheme_name}.xcscheme")
        unless File.exist?(scheme_filepath)
          scheme_filepath = File.join(Xcodeproj::XCScheme.user_data_dir(project_path), "#{scheme_name}.xcscheme")
        end
        UI.user_error!("Scheme '#{scheme_name}' does not exist in Xcode project found at '#{project_path}'") unless File.exist?(scheme_filepath)

        Xcodeproj::XCScheme.new(scheme_filepath)
      end

      def self.description
        "Suppress stabile tests so that 'scan' can run the fragile tests again"
      end

      def self.authors
        ["Lyndsey Ferguson"]
      end

      def self.details
        "Reviews the scan report file to find the passing tests in an Xcode project and then suppresses the tests in the test-suite's source file."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :project_path,
            env_name: "SETUP_FRAGILE_TESTS_FOR_RESCAN_PROJECT_PATH",
            description: "The file path to the Xcode project file",
            verify_block: proc do |value|
              UI.user_error!('No project file for SetupFragileTestsForRescanAction given, pass using `project_path: \'path/to/project.xcodeproj\'`') if value.nil? || value.empty?
              UI.user_error!("SetupFragileTestsForRescanAction cannot find project file at '#{value}'") unless Dir.exist?(value)
              UI.user_error!("The project '#{value}' is not a valid Xcode project") unless File.extname(value).casecmp('.xcodeproj').zero?
              UI.user_error!("The Xcode project at '#{value}' is invalid: missing the project.pbxproj file") unless File.exist?("#{value}/project.pbxproj")
            end,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :scheme,
            env_name: "SETUP_FRAGILE_TESTS_FOR_RESCAN_SCHEME",
            description: "The Xcode scheme used to manage the tests",
            verify_block: proc do |value|
              UI.user_error!('No scheme for SetupFragileTestsForRescanAction given, pass using `scheme: \'scheme name\'`') if value.nil? || value.empty?
            end,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :report_filepath,
            env_name: "SETUP_FRAGILE_TESTS_FOR_RESCAN_TEST_REPORT_FILEPATH",
            description: "The file path to the test report file",
            verify_block: proc do |value|
              UI.user_error!('No test report file for SetupFragileTestsForRescanAction given, pass using `report_filepath: \'path/to/report.xml\'`') if value.nil? || value.empty?
              UI.user_error!("SetupFragileTestsForRescanAction cannot find test report file at '#{value}'") unless File.exist?(value)
            end,
            type: String
          )
        ]
      end

      def self.is_supported?(platform)
        STDOUT.puts "platform: #{platform}"
        [:ios, :mac].include?(platform)
      end
    end
  end
end
