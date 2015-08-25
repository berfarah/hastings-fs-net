describe Hastings::FS::Net do
  before { allow(Hastings).to receive(:pwd).and_return("some_dir") }

  describe ".share?" do
    it "recognizes smb:// as valid" do
      expect(described_class.share? "smb://example/dir").to be Hastings::FS::Net::Samba
    end

    it "recognizes // as valid" do
      expect(described_class.share? "//example/dir").to be Hastings::FS::Net::Cifs
    end

    it "doesn't recognize non-prefixed dirs as valid" do
      expect { described_class.share? "example/dir" }.to raise_error(NotImplementedError)
    end
  end
end
