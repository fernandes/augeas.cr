# augeas

Crystal C Bindings for [Augeas](https://augeas.net/)

## Installation

### Pre-Requisites

Before adding this shard, need to install the libaugeas.

On Mac `brew install augeas`

On Linux `apt-get install libaugeas-dev`

### Crystal

1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
  augeas:
    github: fernandes/augeas
```

2. Run `shards install`

## Usage

```crystal
require "augeas"
```

### Initializing Augeas

Initial step is always setup Augeas to your root path:

```crystal
augeas = Augeas.new(root: "/path/to/root")
```

### Getting a Value

Consider getting value for a postgresql conf setting:

```crystal
augeas_file = augeas.load_file("/var/lib/pgsql/data/postgresql.conf")
augeas_file.get("data_directory")
# => "/var/lib/postgresql/8.4/main"
```

### Setting a value

```crystal
augeas_file = augeas.load_file("/var/lib/pgsql/data/postgresql.conf")
augeas_file.set("data_directory", "/my/new/path/to/postgresql/8.4/main")
# => true
augeas.save # this is a important step, do not forget to save
```

## Development

Install the libraries on your local environment, write a spec, make it pass and :shipit:

`LibAugeas` has all the methods mapped, the comments there are from the [C header](https://github.com/hercules-team/augeas/blob/4ceb8403039f57df9ecbcdeb08da7a356bd236fc/src/augeas.h).

Augeas needs to pass a pointer to `Augeas` on every method, that's why we pass the `Augeas` crystal object to `Augeas::File`, so we can encapsulate the logic to manipulate a file inside it. We have the penalty on needing to call `Augeas#save`, but this is something we can abstract in the future with kind of DSL/block.

This library is on early stages, the next steps are (to be developed as needed):

- [ ] Better error handling
  - [ ] Specially when there are more than 1 node
- [ ] Support augeas operations
  - [ ] Single Node Operations (`aug_rm`, `aug_mv`, `aug_cp`)
  - [ ] Deal with matches (`aug_match`)
  - [ ] Support `aug_ns_*` functions

About error handling, as we need to check the error messages on `Augeas`, the idea is to centralize all the error message / exceptions in one place, for now keeping in one method works, maybe a refactor to a new file can make sense.

## Contributing

1. Fork it (<https://github.com/fernandes/augeas/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Celso Fernandes](https://github.com/fernandes)
