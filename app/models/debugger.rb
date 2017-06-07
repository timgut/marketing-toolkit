class Debugger < ApplicationRecord
  belongs_to :datum,    optional: true
  belongs_to :document, optional: true
  belongs_to :user,     optional: true
end