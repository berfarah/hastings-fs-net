describe Hastings::Dsl::FS::Net::File do
  subject { Hastings::Dsl.new { network_share "//my-share/foo/bar/baz.txt" } }
  before do
    FileUtils.touch "baz.txt"
    FileUtils.mkdir_p File.join Hastings.root, "my-share/foo/bar"
    FileUtils.touch File.join Hastings.root, "my-share/foo/bar/baz.txt"
    FileUtils.touch File.join Hastings.root, "my-share/foo/bar/asdf.txt"
  end

  describe "#file" do
    it "is able to reference #meta" do
      expect(subject.meta.network_shares).to be_a Hastings::FS::Net::Registry
    end

    context "given a normal directory" do
      it "returns Hastings::File" do
        expect(subject.file("baz.txt")).to be_a Hastings::File
      end
    end

    context "given a netork directory" do
      it "returns Hastings::FS::Net::ProxyFile" do
        expect(subject.file("//my-share/foo/bar/baz.txt"))
          .to be_a Hastings::FS::Net::ProxyFile
      end

      it "does partial matches" do
        expect(subject.file("//my-share/foo/bar/asdf.txt"))
          .to be_a Hastings::FS::Net::ProxyFile
      end
    end
  end
end
