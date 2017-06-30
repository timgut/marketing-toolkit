class ApplicationJob < ActiveJob::Base
  include SuckerPunch::Job

  before_perform do |job|
    SuckerPunch.lock!
  end

  after_perform do |job|
    SuckerPunch.unlock!
  end
end
