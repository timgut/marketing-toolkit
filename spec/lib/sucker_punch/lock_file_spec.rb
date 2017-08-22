# require 'rails_helper'

# RSpec.describe SuckerPunch, type: :module do
#   describe "mattr_accessor" do
#     it ".lock_file" do
#       expect(SuckerPunch).to respond_to(:lock_file)
#       expect(SuckerPunch).to respond_to(:lock_file=)
#     end
#   end

#   describe "Class Methods" do
#     describe ".lock!" do
#       it "creates the lock file" do
#         SuckerPunch.lock!
#         expect(File.file?(SuckerPunch.lock_file)).to eq true
#       end
#     end

#     describe ".unlock!" do
#       it "deletes the lock file" do
#         SuckerPunch.lock!
#         SuckerPunch.unlock!
#         expect(File.file?(SuckerPunch.lock_file)).to eq false
#       end
#     end
#   end
# end