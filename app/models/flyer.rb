class Flyer < ApplicationRecord
  has_and_belongs_to_many :campaigns
  has_and_belongs_to_many :users
  
  has_many :data
  
  belongs_to :template

  def respond_to_missing?(method, include_private = false)
    if data_keys.include?(method)
      true
    else
      super
    end
  end

  def method_missing(method, *arguments, &block)
    if data_keys.include?(method)
      data.__send__(:method)
    else
      super
    end
  end

  private

  def data_keys
    @data_keys ||= data.map(&:key).map(&:to_sym)
  end
end
