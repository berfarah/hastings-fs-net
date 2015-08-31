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
        expect { subject }.to raise_error(Hastings::FS::Net::InvalidError)
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

  context "when inherited" do
    before { class Foo < described_class; end }
    subject do
      Foo.prefix = prefix
      Foo.type = type
      Foo
    end
    let(:prefix) { :smb }
    let(:type) { :cifs }

    describe ".valid?" do
      it "is false for a different prefix" do
        expect(subject.valid? "asdf://my-share/foo").to be_falsey
      end

      it "is true for no prefix" do
        expect(subject.valid? "//my-share/foo").to be_truthy
      end

      it "is true for the correct prefix" do
        expect(subject.valid? "smb://my-share/foo").to be_truthy
      end
    end

    context "Instance Methods:" do
      # Instance methods
      subject { super().new "smb://my-share/foo/bar", **args }
      let(:args) { { username: "foo", password: "bar" } }

      describe "#type" do
        subject { super().type }
        it { is_expected.to eq type }
      end

      describe "#prefix" do
        subject { super().prefix }
        it { is_expected.to eq prefix }
      end

      describe "#command" do
        subject { super().command }
        it do
          is_expected.to eq "mount -t cifs //my-share/foo "\
          "/var/tmp/hastings/my-share/foo -o username='foo',password='bar'"
        end
      end

      describe "#auth_opts" do
        subject { super().auth_opts }
        it { is_expected.to eq "-o username='foo',password='bar'" }
      end
    end
  end
end
