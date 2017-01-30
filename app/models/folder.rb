class Folder < ApplicationRecord
  belongs_to :parent, class_name: name, foreign_key: :parent_id
  belongs_to :user

  has_many :children, class_name: name, foreign_key: :parent_id, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :flyers, dependent: :destroy

  validates_presence_of :name, :path
  validates_presence_of :parent, unless: :is_root

  default_scope ->{ order(path: :asc) }

  class << self
    def roots
      where(parent_id: nil)
    end
  end

  # Returns list of ancestors, starting from parent until root.
  #   subchild1.ancestors # => [child1, root]
  def ancestors
    node, nodes = self, []
    nodes << node = node.parent while node.parent
    nodes
  end

  # Returns the root node of the tree.
  def root
    node = self
    node = node.parent while node.parent
    node
  end

  # Returns all siblings of the current node.
  #   subchild1.siblings # => [subchild2]
  def siblings
    self_and_siblings.select{|f| f.id != self.id}
  end

  # Returns all siblings and a reference to the current node.
  #   subchild1.self_and_siblings # => [subchild1, subchild2]
  def self_and_siblings
    parent ? parent.children : self.class.roots
  end
end
