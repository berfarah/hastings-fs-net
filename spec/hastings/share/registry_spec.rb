describe Hastings::FS::Net::Registry do
  subject { Hastings::FS::Net::Registry.new }

  let(:path) { "//some_path/here" }
  Paths = Class.new { extend Hastings::FS::Net::Paths }

  before { allow(Hastings).to receive(:pwd).and_return("my_local_dir") }

  it "should instantiate with empty shares" do
    expect(subject.shares).to be_empty
  end

  describe "#find_by_path" do
    context "when the path already exists" do
      it "returns the share" do
        subject.add(path)
        expect(subject.find_by_path(path).path).to eq path
      end
    end

    context "when the path doesn't exist" do
      it "returns nil" do
        expect(subject.shares).to be_empty
        expect(subject.find_by_path path).to be nil
      end
    end
  end

  describe "#add" do
    context "when given a new share" do
      it "adds it" do
        subject.add(path)
        expect(subject.find_by_path path).to be_truthy
      end
    end

    context "when given an existing share" do
      it "doesn't add it" do
        subject.add(path)
        expect(subject.find_by_path path).to be_truthy
        subject.add(path)
        expect(subject.shares.length).to be 1
      end
    end
  end

  context "#remove" do
    it "unregisters the share" do
      subject.add(path)
      expect(subject.shares.length).to be 1
      subject.remove(path)
      expect(subject.shares).to be_empty
    end
  end

  context "#paths" do
    it "returns an array of paths" do
      subject.add(path)
      expect(subject.paths).to be_an Array
      expect(subject.paths.first).to eq path
    end
  end

  context "#commands" do
    it "returns an array of commands" do
      subject.add(path)
      expect(subject.commands).to be_an Array
      expect(subject.commands.first).to be_a String
    end
  end
end
