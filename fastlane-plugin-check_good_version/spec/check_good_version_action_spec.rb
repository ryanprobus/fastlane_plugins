require 'fastlane'

describe Fastlane do
  describe Fastlane::FastFile do
    describe "CheckGoodVersionAction" do
      context "WHEN calling action with the GD.framework installed" do
        before do
          allow(Fastlane::Actions::CheckGoodVersionAction).to receive(:sh).with(/xcode-select\s*--print-path/, anything).and_return(File.expand_path('./spec/fixtures/xcodes/xcode_with_good'))
        end

        it "THEN the version number is returned" do
          result = Fastlane::FastFile.new.parse("lane :test do
            check_good_version
          end").runner.execute(:test)

          expect(result).to eq("99.0.1")
        end
      end

      context "WHEN calling action with the GD.framework not installed" do
        before do
          allow(Fastlane::Actions::CheckGoodVersionAction).to receive(:sh).with(/xcode-select\s*--print-path/, anything).and_return(File.expand_path('./spec/fixtures/xcodes/xcode_without_good'))
        end

        it "THEN the version number is returned" do
          check_good_version_no_good_sdk = "lane :test do
            check_good_version
          end"

          expect { Fastlane::FastFile.new.parse(check_good_version_no_good_sdk).runner.execute(:test) }.to(
            raise_error(FastlaneCore::Interface::FastlaneError) do |error|
              expect(error.message).to match(/The Good framework is not installed/)
            end
          )
        end
      end
    end
  end
end
