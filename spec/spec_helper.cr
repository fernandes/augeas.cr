require "spec"
require "../src/augeas"

SPEC_PATH     = File.expand_path(File.dirname(__FILE__))
FIXTURES_PATH = File.join(SPEC_PATH, "fixtures")

Spec.before_each do
  psql_path = File.join(FIXTURES_PATH, "var", "lib", "pgsql", "data")
  File.write(File.join(psql_path, "postgresql.conf"), File.read(File.join(psql_path, "postgresql.original.conf")))
end

Spec.after_each do
  psql_path = File.join(FIXTURES_PATH, "var", "lib", "pgsql", "data")
  File.write(File.join(psql_path, "postgresql.conf"), File.read(File.join(psql_path, "postgresql.original.conf")))
end
