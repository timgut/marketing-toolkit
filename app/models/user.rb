class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :flyers
  has_and_belongs_to_many :images


  class << self
    def current_user=(current_user)
      Thread.current[:current_user] = current_user
    end

    def current_user
      Thread.current[:current_user]
    end
  end
end
