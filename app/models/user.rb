class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :flyers
  has_and_belongs_to_many :images

  has_many :folders

  after_create :create_root_folder

  def root_folder
    folders.find_by(is_root: true)
  end

  protected

  def create_root_folder
    folder = Folder.new(user_id: self.id, name: "Root", path: "/", is_root: true, parent_id: nil)
    folder.save!(validate: false)
  end
end
