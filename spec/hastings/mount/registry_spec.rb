describe Hastings::Mount::Registry do
  subject { Hastings::Mount::Registry.new }

  before do
    allow(Hastings).to receive(:pwd).and_return("my_local_dir")

    @share = Hastings::Mount::Share.new "//some_path/here", OpenStruct.new
    allow(@share).to receive(:mounted?)
    allow(@share).to receive(:mount!)
    allow(@share).to receive(:mount)
    allow(@share).to receive(:unmount!)
    allow(@share).to receive(:unmount)
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

      context "if it isn't mounted" do
        it "mounts it" do
          expect(@share).to receive(:mount!)
          subject.add(@share)
        end
      end

      context "if it is mounted" do
        it "adds and mounts it" do
          expect(@share).to receive(:mounted?).and_return(true)
          expect(@share).not_to receive(:mount!)
          subject.add(@share)
        end
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
      expect(@share).to receive(:unmount!)
      subject.remove(@share)
      expect(subject.shares).to be_empty
    end
  end

  context "#mount" do
    it "calls #mount on the shares" do
      subject.add(@share)
      expect(@share).to receive(:mount)
      subject.mount
    end
  end

  context "#unmount" do
    it "calls #unmount on the shares" do
      subject.add(@share)
      expect(@share).to receive(:unmount)
      subject.unmount
    end
  end
end
