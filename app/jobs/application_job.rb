class ApplicationJob < ActiveJob::Base
  include SuckerPunch::Job
  # This isn't turning out to be as useful as I thought.

  # before_perform do |job|
  #   SuckerPunch.lock!
  # end

  # after_perform do |job|
  #   SuckerPunch.unlock!
  # end
end
