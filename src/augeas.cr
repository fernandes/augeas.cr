require "./lib_augeas"

# This is the main Augeas class, the entrypoint to all Augeas operations
class Augeas
  # Error raised when a file is loaded and Augeas has no lens to process it
  class LensNotFound < Exception; end

  VERSION = "0.1.0"

  # Root specified on the `.new`
  getter :root

  # Load path for augeas lens specified on the `.new
  getter :loadpath

  # Augeas control flags specified on the `.new`
  getter :flags

  # Initiale the class specifying your root, the lens loadpath and any flags
  # Right now we are only forwaring the flags to LibAugeas, maybe in the future
  # we can handle it more the _crystal way™_
  #
  # ```
  # Augeas.new(root: "/path/to/root", loadpath: "/path/to/leans", flags: 2)
  # ```
  def initialize(@root : String, @loadpath : String? = nil, @flags : UInt32 = 0)
    @pointer = LibAugeas.aug_init(root, loadpath, flags)
  end

  # Load a file into the Augeas tree
  #
  # ```
  # load_file("/path/to/my-config-file")
  # ```
  def load_file(path : String)
    LibAugeas.aug_load_file(@pointer, path)
    check_aug_error
    Augeas::File.new(augeas: self, path: path)
  end

  # Save all changes in the augeas tree to the respective files
  # ps: Only modified files are written
  #
  # tip: Do not forget to call this method after performing changes
  def save
    LibAugeas.aug_save(self)
  end

  # Check error on augeas C struct
  #
  # The main idea is to keep here all possible errors that can happen
  #
  # Initially check augeas for an error, if not returns true, otherwise
  # Fetch the `error_message`, `error_minor_message` and `error_details`
  #
  # After that checks the `error_message` against known values, if any is found
  # method raises an an exception passing error details as its message
  def check_aug_error
    return true if LibAugeas.aug_error(self) == 0

    msg = LibAugeas.aug_error_message(self)
    if (msg)
      error_message = String.new(msg)
    end

    msg = LibAugeas.aug_error_minor_message(self)
    if (msg)
      error_minor_message = String.new(msg)
    end

    msg = LibAugeas.aug_error_details(self)
    if (msg)
      error_details = String.new(msg)
    end

    case error_message
    when "Lens not found"
      raise LensNotFound.new(error_details)
    end
  end

  # Close Augeas C Struct (to free everything related to it)
  def finalize
    LibAugeas.aug_close(self)
  end

  # Pointer to C Struct
  def to_unsafe
    @pointer
  end
end

require "./augeas/file.cr"
