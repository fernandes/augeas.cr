require "./spec_helper"

private def root
  FIXTURES_PATH
end

private def postgres_file
  "/var/lib/pgsql/data/postgresql.conf"
end

describe "LibAugeas" do
  it "augeas" do
    augeas = LibAugeas.aug_init(root, nil, 0)
    LibAugeas.aug_load_file(augeas, postgres_file)

    result = Pointer(LibC::Char).malloc(1)
    LibAugeas.aug_get(augeas, "/files#{postgres_file}/data_directory", pointerof(result))

    String.new(result).should eq("/var/lib/postgresql/8.4/main")
  end
end
