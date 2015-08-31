describe Hastings::Dsl::FS::Net::Dir do
  subject { Hastings::Dsl.new { network_share "//my-share/foo/bar/baz" } }
  before do
    FileUtils.mkdir_p "baz"
    FileUtils.mkdir_p File.join Hastings.root, "my-share/foo/bar/baz"
  end

  describe "#dir" do
    it "is able to reference #meta" do
      expect(subject.meta.network_shares).to be_a Hastings::FS::Net::Registry
    end

    context "given a normal directory" do
      it "returns Hastings::Dir" do
        expect(subject.dir("baz")).to be_a Hastings::Dir
      end
    end

    context "given a netork directory" do
      it "returns Hastings::FS::Net::ProxyDir" do
        expect(subject.dir("//my-share/foo/bar/baz"))
          .to be_a Hastings::FS::Net::ProxyDir
      end

      it "does partial matches" do
        expect(subject.dir("//my-share/foo"))
          .to be_a Hastings::FS::Net::ProxyDir
      end
    end
  end
end
