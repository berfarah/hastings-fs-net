describe Hastings::Mount::ProxyDir do
  subject { described_class.new share }
  let(:path) { "//share/my/example/dir/goes/here" }
  let(:share) { Hastings::Mount::Share.new path, OpenStruct.new }

  before do
    allow(Hastings).to receive(:pwd).and_return("some_dir")
    FileUtils.mkdir_p share.local_full_path
  end

  it { is_expected.to be_a Hastings::Dir }

  describe "#path" do
    it "is the share's local path" do
      expect(subject.path).to eq(
        File.absolute_path("some_dir/share/my/example/dir/goes/here"))
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
