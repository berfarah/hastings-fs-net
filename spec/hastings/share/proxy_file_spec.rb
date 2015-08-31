describe Hastings::FS::Net::ProxyFile do
  subject { described_class.new share }
  let(:path) { "//share/my/example/dir/goes/here.txt" }
  let(:share) { Hastings::FS::Net::Share.new path, {} }
  before do
    FileUtils.mkdir_p File.dirname share.local_full_path
    FileUtils.touch share.local_full_path
  end

  it { is_expected.to be_a Hastings::File }

  describe "#path" do
    it "is the share's local path" do
      expect(subject.path).to eq(
        File.join(Hastings.root, *%w(share my example dir goes here.txt)))
    end
  end

  describe "#remote_path" do
    it "is the share's remote url" do
      expect(subject.remote_path).to eq path
    end
  end

  describe "#share" do
    it "is the share" do
      expect(subject.share).to eq share
    end
  end
end
