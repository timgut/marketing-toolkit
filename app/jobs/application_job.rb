# == Testing
# SuckerPunch includes an inline testing module that runs the job immediately.
# Typically, this module is used in tests, but we can also use it here to help
# debug jobs locally. Include this line to run jobs within the request. You
# can  then run a REPL session (such as pry) within a job to debug it.
#
# require 'sucker_punch/testing/inline'

class ApplicationJob < ActiveJob::Base
  include SuckerPunch::Job
end
