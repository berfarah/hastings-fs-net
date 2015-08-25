describe Hastings::FS::Net::Share do
  subject { described_class.new path, {} }
  let(:path) { "//share/some/path" }
  before do
    allow(Hastings).to receive(:pwd).and_return("")
  end

  describe ".new" do
    it "saves the path" do
      expect(subject.path).to eq path
    end

    context "given a path with a protocol" do
      let(:path) { "smb:" << super() }
      it "strips the protocol" do
        expect(subject.path).to eq path[4..-1]
      end
    end

    context "given an invalid share path" do
      let(:path) { super()[2..-1] }
      it "fails with an Invalid error" do
        expect { subject }.to raise_error(Hastings::FS::Net::Invalid)
      end
    end
  end

  describe "#==" do
    it "compares on base_path" do
      other = described_class.new "//share/some/other/path"
      wrong = described_class.new "//something/else/entirely"
      expect(subject == other).to be true
      expect(subject == wrong).to be false
    end
  end
end
