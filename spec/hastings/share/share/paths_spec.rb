describe Hastings::FS::Net::Paths do
  subject do
    Struct.new(:path) { include Hastings::FS::Net::Paths }.new path
  end
  let(:path) { "//share_name/long/path/goes/here" }

  describe "#base_dirs" do
    it "returns the share domain and share directory" do
      expect(subject.base_dirs).to eq %w(share_name long)
    end
  end

  describe "#base_path" do
    it "returns the hare domain and share directory in path form" do
      expect(subject.base_path).to eq("//share_name/long")
    end
  end

  describe "#local_dirs" do
    it "returns the rest of the directories (to be fetched locally)" do
      expect(subject.local_dirs).to eq %w(path goes here)
    end
  end

  describe "#local_base_path" do
    it "returns the path where things will be mounted" do
      expect(subject.local_base_path).to eq(
        File.join Hastings.root, "share_name", "long")
    end
  end

  describe "#local_full_path" do
    it "returns the path where things will be mounted" do
      expect(subject.local_full_path)
        .to eq(File.join Hastings.root, "share_name",
                         "long", "path", "goes", "here")
    end
  end
end
