# Augeas::File is an abstraction to help dealing with config file

# Usually the full path to the config file, needs to be speficied, when
# getting and setting values. Using this file, this is not needed.
class Augeas::File
  # Path to the config file, specified in the `.new` method
  getter :path

  # Initiale Augeas::File abstraction, `@augeas` is needed to perform
  # augeas operations on it, and the `@path` is the full path to the
  # config file.
  #
  # ```
  # augeas = Augeas.new(root: "/path/to")
  # augeas_file = Augeas::File.new(augeas: augeas, path: "/path/to/config-file")
  # ```
  def initialize(@augeas : Augeas, @path : String)
  end

  # Get a settings value from the config file
  #
  # Let take postgresql as example, consider we have a config file like this
  #    data_directory = '/var/lib/postgresql/8.4/main'          # use data in another directory
  #
  # After instantiating the class, get can be used as:
  #
  # ```
  # get("data_directory")
  # # => "/var/lib/postgresql/8.4/main"
  # ```
  def get(key)
    result = Pointer(LibC::Char).malloc(1)
    full_path = "/files#{path}/#{key}"
    LibAugeas.aug_get(@augeas, full_path, pointerof(result))
    return String.new(result) if result

    nil
  end

  # Set a settings value on the config file
  # As Augeas keeps the modifications in memory, don't
  # forget to call `Augeas#save` after making changes
  #
  # ```
  # set("data_directory", "/path/to/data_directory")
  # ```
  def set(key, value)
    full_path = "/files#{path}/#{key}"
    augeas_ret = LibAugeas.aug_set(@augeas, full_path, value)
    return true if augeas_ret == 0

    false
  end

  # Return the lens name for this file
  #
  # When Augeas loads a file, it associates a lens with it, so
  # this method looks up and returns the lens name
  def lens_name
    LibAugeas.aug_defvar(@augeas, "info", "/augeas/files#{path}")

    lens_name = Pointer(LibC::Char).malloc(1)
    LibAugeas.aug_get(@augeas, "$info/lens", pointerof(lens_name))
    if (lens_name)
      String.new(lens_name)
    else
      nil
    end
  end
end
