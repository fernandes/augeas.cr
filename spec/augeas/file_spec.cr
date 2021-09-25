require "../spec_helper"

private def init_augeas_file
  augeas_root = File.join(SPEC_PATH, "fixtures")
  Augeas.new(root: augeas_root).load_file("/var/lib/pgsql/data/postgresql.conf")
end

describe Augeas::File do
  it "gets the value of a config file" do
    augeas_file = init_augeas_file
    augeas_file.get("data_directory").should eq("/var/lib/postgresql/8.4/main")
  end

  it "sets the value of a config in the file" do
    augeas_file = init_augeas_file
    augeas_file.set("data_directory", "/var/lib/postgresql/8.4/mainz").should be_truthy
    augeas_file.get("data_directory").should eq("/var/lib/postgresql/8.4/mainz")
  end

  it "sets the value of a (new) config in the file" do
    augeas_file = init_augeas_file
    augeas_file.set("foo", "bar").should be_truthy
    augeas_file.get("foo").should eq("bar")
  end

  describe "#lens_name" do
    it "returns the lens name" do
      augeas_file = init_augeas_file
      augeas_file.lens_name.should eq("@Postgresql")
    end
  end
end
