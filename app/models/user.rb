class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :flyers
  has_and_belongs_to_many :images

  has_many :folders
  has_many :image_folders
  has_many :flyer_folders

  after_create :create_root_folders

  class << self
    def current_user=(current_user)
      Thread.current[:current_user] = current_user
    end

    def current_user
      Thread.current[:current_user]
    end
  end

  def root_image_folder
    image_folders.find_by(is_root: true)
  end

  def root_flyer_folder
    flyer_folders.find_by(is_root: true)
  end

  protected

  def create_root_folders
    ImageFolder.new(user_id: self.id, name: "Root", path: "/", is_root: true, parent_id: nil).save!(validate: false)
    FlyerFolder.new(user_id: self.id, name: "Root", path: "/", is_root: true, parent_id: nil).save!(validate: false)
  end
end
