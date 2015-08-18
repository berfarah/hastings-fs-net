describe Hastings::Mount do
  before { allow(Hastings).to receive(:pwd).and_return("some_dir") }

  describe ".mount?" do
    it "recognizes smb:// as valid" do
      expect(described_class.mount? "smb://example/dir").to be Hastings::Mount::Samba
    end

    it "recognizes // as valid" do
      expect(described_class.mount? "//example/dir").to be Hastings::Mount::Cifs
    end

    it "doesn't recognize non-prefixed dirs as valid" do
      expect { described_class.mount? "example/dir" }.to raise_error(NotImplementedError)
    end
  end

  describe ".registry" do
    subject { super().registry }
    it { is_expected.to be_a Hastings::Mount::Registry }
  end

  describe ".mount!" do
    subject { super().mount!("//share/my/example") }
    before do
      expect_any_instance_of(Hastings::Mount::Cifs).to receive(:mounted?)
      expect_any_instance_of(Hastings::Mount::Cifs).to receive(:mount!).and_return(true)
      FileUtils.mkdir_p "some_dir/share/my/example"
    end

    it { is_expected.to be_a Hastings::Mount::ProxyDir }
  end

  describe ".unmount!" do
    subject { super().unmount!("//some_path") }

    it "removes the mount from the registry" do
      expect_any_instance_of(Hastings::Mount::Registry).to receive(:remove)
      subject
    end
  end
end
