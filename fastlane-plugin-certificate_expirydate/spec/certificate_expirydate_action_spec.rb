describe Fastlane::Actions::CertificateExpirydateAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The certificate_expirydate plugin is working!")

      Fastlane::Actions::CertificateExpirydateAction.run(nil)
    end
  end
end
