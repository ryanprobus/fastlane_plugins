module Fastlane
  module Helper
    class GoodifyInfoPlistVersionHelper
      include Comparable

      attr_accessor :major_version

      attr_accessor :minor_version

      attr_accessor :patch_version

      attr_accessor :build_number

      def initialize(version_string)
        match = /^(?<major_version>\d+)\.(?<minor_version>\d+)\.(?<patch_version>\d+)\.(?<build_number>\d+)$/.match(version_string) || {}

        @major_version = (match[:major_version] || '0').to_i
        @minor_version = (match[:minor_version] || '0').to_i
        @patch_version = (match[:patch_version] || '0').to_i
        @build_number = (match[:build_number] || '0').to_i
      end

      def to_s
        "#{@major_version}.#{@minor_version}.#{@patch_version}.#{@build_number}"
      end

      def <=>(other)
        major_version_comparison = self.major_version <=> other.major_version
        minor_version_comparison = self.minor_version <=> other.minor_version
        patch_version_comparison = self.patch_version <=> other.patch_version
        build_number_comparison = self.build_number <=> other.build_number

        if !major_version_comparison.zero?
          major_version_comparison
        elsif !minor_version_comparison.zero?
          minor_version_comparison
        elsif !patch_version_comparison.zero?
          patch_version_comparison
        elsif !build_number_comparison.zero?
          build_number_comparison
        else
          0
        end
      end
    end
  end
end
