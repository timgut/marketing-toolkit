# This isn't turning out to be as useful as I thought.

# module SuckerPunch
#   mattr_accessor :lock_file

#   class << self
#     def lock!
#       FileUtils.touch(lock_file)
#     end

#     def unlock!
#       FileUtils.rm(lock_file)
#     end
#   end
# end

# SuckerPunch.lock_file = Rails.root.join("sucker_punch.lock")
