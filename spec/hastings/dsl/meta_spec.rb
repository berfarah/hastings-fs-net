describe Hastings::Dsl::FS::Net::Meta do
  subject { Class.new.extend(Hastings::Dsl::FS::Net::Meta) }

  describe "#network_shares" do
    subject { super().network_shares }
    it { is_expected.to be_a Hastings::FS::Net::Registry }
  end

  describe "#network_share_paths" do
    it "delegates to Registry" do
      expect(subject.network_shares).to receive(:paths)
      subject.network_share_paths
    end
  end

  describe "#network_share_commands" do
    it "delegates to Registry" do
      expect(subject.network_shares).to receive(:commands)
      subject.network_share_commands
    end
  end

  describe "#network_share=" do
    it "adds items to the registry" do
      path = "//mymount/foo/bar"
      expect(subject.network_shares.shares).to be_empty
      subject.network_share = path
      expect(subject.network_shares.shares.length).to be 1
      expect(subject.network_shares.paths.first).to eq path
    end
  end
end
