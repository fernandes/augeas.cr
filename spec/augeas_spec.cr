require "./spec_helper"

private def root
  FIXTURES_PATH
end

private def init_augeas
  Augeas.new(root: root)
end

describe Augeas do
  it "stores a pointer to lib augeas" do
    augeas = Augeas.new(root: root)
    augeas.to_unsafe.should be_a(Pointer(LibAugeas::Augeas))
  end

  it "returns an Augeas::File" do
    augeas = init_augeas
    augeas_file = augeas.load_file("/var/lib/pgsql/data/postgresql.conf")
    augeas_file.should be_a(Augeas::File)
  end

  context "saving a file" do
    it "saves the file correctly" do
      augeas = init_augeas
      augeas_file = augeas.load_file("/var/lib/pgsql/data/postgresql.conf")
      augeas_file.set("data_directory", "/var/lib/postgresql/8.4/mainz")
      augeas.save

      file_content = File.read(File.join(FIXTURES_PATH, "var/lib/pgsql/data/postgresql.conf"))
      file_content.matches?(Regex.new("data_directory = '/var/lib/postgresql/8.4/mainz'")).should be_truthy
    end
  end

  describe "error handling" do
    it "raises exception when can find a lens for a file" do
      augeas = init_augeas
      expect_raises(Augeas::LensNotFound, "can not determine lens to load file /unknown_file") do
        augeas_file = augeas.load_file("/unknown_file")
      end
    end
  end
end
