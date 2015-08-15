describe Hastings::Mount::Share do
  subject { described_class.new path, OpenStruct.new }
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
        expect { subject }.to raise_error(Hastings::Mount::Invalid)
      end
    end
  end

  describe "#==" do
    it "compares on base_path" do
      other = described_class.new "//share/some/other/path", OpenStruct.new
      wrong = described_class.new "//something/else/entirely", OpenStruct.new
      expect(subject == other).to be true
      expect(subject == wrong).to be false
    end
  end

  describe "#mounted?" do
    it "checks the CLI against path and local_base_path" do
      expect_any_instance_of(Hastings::Mount::Cli).to receive(:mounted?)
      subject.mounted?
    end
  end

  describe "#mount" do
    it "calls mount via the CLI" do
      expect_any_instance_of(Hastings::Mount::Cli).to receive(:mount)
      subject.mount
    end

    context "when the mount is failing" do
      it "returns false after trying 3 times" do
        expect(Hastings::Shell).to receive(:run).exactly(3)
          .times { fail Hastings::Shell::Error }
        expect(subject.mount).to be false
      end
    end
  end

  describe "#unmount" do
    it "calls unmount via the CLI" do
      expect_any_instance_of(Hastings::Mount::Cli).to receive(:unmount)
      subject.unmount
    end

    context "when the unmount is failing" do
      it "returns false after trying 3 times" do
        expect(Hastings::Shell).to receive(:run).exactly(3)
          .times { fail Hastings::Shell::Error }
        expect(subject.unmount).to be false
      end
    end
  end

  describe "mount!" do
    it "fails with NoMount if it couldn't mount" do
      allow_any_instance_of(Hastings::Mount::Share).to receive(:mount)
      expect { subject.mount! }.to raise_error(Hastings::Mount::NoMount)
    end
  end

  describe "unmount!" do
    it "fails with Busy if it couldn't unmount" do
      allow_any_instance_of(Hastings::Mount::Share).to receive(:unmount)
      expect { subject.unmount! }.to raise_error(Hastings::Mount::Busy)
    end
  end
end
