describe Hastings::FS::Net::Registry do
  subject { Hastings::FS::Net::Registry.new }

  before do
    allow(Hastings).to receive(:pwd).and_return("my_local_dir")

    @share = Hastings::FS::Net::Share.new "//some_path/here", {}
    allow(@share).to receive(:mounted?)
  end

  it "should instantiate with empty shares" do
    expect(subject.shares).to be_empty
  end

  describe "#add" do
    context "when given a new share" do
      it "adds it" do
        subject.add(@share)
        expect(subject.shares).to include(@share)
      end
    end

    context "when given an existing share" do
      it "doesn't add it" do
        subject.add(@share)
        expect(subject.shares).to include(@share)
        subject.add(@share)
        expect(subject.shares.length).to be 1
      end
    end
  end

  describe "#added?" do
    context "when the share already exists" do
      it "returns the share" do
        subject.add(@share)
        expect(subject.shares).to include(@share)
        expect(subject.added? @share).to be @share
      end
    end

    context "when the share doesn't exist" do
      it "returns nil" do
        expect(subject.shares).to be_empty
        expect(subject.added? @share).to be nil
      end
    end
  end

  context "#remove" do
    it "unmounts and deletes the share" do
      subject.add(@share)
      expect(subject.shares).to include(@share)
      subject.remove(@share)
      expect(subject.shares).to be_empty
    end
  end
end
