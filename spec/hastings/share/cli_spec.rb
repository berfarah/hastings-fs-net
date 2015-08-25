require "hastings/fs/net/cli"
require "ostruct"

describe Hastings::FS::Net::Cli::Arguments do
  subject { described_class.new struct }

  describe "#type" do
    context "when given a type" do
      let(:struct) { OpenStruct.new type: :cifs }

      it "returns the type with the 't' flag" do
        expect(subject.type).to eq("-t #{struct.type}")
      end
    end

    context "when no type is given" do
      let(:struct) { OpenStruct.new }

      it "returns nil" do
        expect(subject.type).to be nil
      end
    end
  end

  describe "#opts" do
    let(:struct) { OpenStruct.new username: user, password: pass, read_only: ro }
    let(:user) {}
    let(:ro) {}
    let(:pass) {}

    describe "when given a username and password" do
      let(:user) { "scrooge" }
      let(:pass) { "12345" }

      it "returns username/password options and default read-write opts" do
        expect(subject.opts).to eq("-o username='#{user}',"\
                                   "password='#{pass}' -o rw")
      end
    end

    describe "when given a username and no password" do
      let(:user) { "scrooge" }

      it "returns default read-write opts" do
        expect(subject.opts).to eq("-o rw")
      end
    end

    describe "when given a username or password with single quotes" do
      let(:user) { %(!\'") }
      let(:pass) { %(!\'"-_) }

      it "escapes single quotes" do
        expect(subject.opts).to eq("-o username='!\'\"',"\
                                   "password='!\'\"-_' -o rw")
      end
    end

    describe "when read_only is set to true" do
      let(:ro) { true }

      it "returns 'ro'" do
        expect(subject.opts).to eq("-o ro")
      end
    end
  end
end

describe Hastings::FS::Net::Cli do
  subject { described_class.new OpenStruct.new }

  describe "#mounted?" do
    subject { super().mounted?("", "") }
    before do
      allow_any_instance_of(Hastings::Shell).to receive(:run)
        .with("mount | grep '' | grep ''") { rval }
    end

    context "when it gets an empty string back" do
      let(:rval) { fail Hastings::Shell::Error }
      it { is_expected.to be false }
    end

    context "when the string contains a mount" do
      let(:rval) { "example mount" }
      it { is_expected.to be true }
    end
  end

  describe "#mount" do
    subject { super().mount("remote", "local") }
    it "creates a directory, then mounts the remote to the local" do
      expect(Hastings::Shell).to receive(:run)
        .with("mkdir -p local")
      expect(Hastings::Shell).to receive(:run)
        .with("mount -o rw remote local")
      subject
    end
  end

  describe "#unmount" do
    subject { super().unmount("remote") }
    it "unmounts the remote drive" do
      expect(Hastings::Shell).to receive(:run)
        .with("umount remote")
      subject
    end
  end
end
