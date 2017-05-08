module Tree
  extend ActiveSupport::Concern

  included do
    belongs_to :parent, class_name: name, foreign_key: "parent_id", counter_cache: nil, optional: true
    has_many   :children, -> { order(:title) }, class_name: name, foreign_key: "parent_id", dependent: :destroy
  end

  module ClassMethods
    def roots
      where(parent_id: nil).order(:title)
    end

    def root
      roots.first
    end
  end

  # Returns list of ancestors, starting from parent until root.
  #
  #   subchild1.ancestors # => [child1, root]
  def ancestors
    if @nodes.nil?
      node, nodes = self, []
      nodes << node = node.parent while node.parent
      @nodes = nodes
    end

    @nodes
  end

  # Returns a string of ancestors delimited by a forward slash.
  #
  #  campaign.path # => "/Campaign 1/Fall/Get Out The Vote"
  def path
    (ancestors.reverse << self).collect{|c| "/#{c.title}"}.sort{|a,b| a <=> b}.join
  end

  # Returns the root node of the tree.
  def root
    node = self
    node = node.parent while node.parent
    node
  end

  # Returns all siblings of the current node.
  #
  #   subchild1.siblings # => [subchild2]
  def siblings
    self_and_siblings - [self]
  end

  # Returns all siblings and a reference to the current node.
  #
  #   subchild1.self_and_siblings # => [subchild1, subchild2]
  def self_and_siblings
    parent ? parent.children : self.class.roots
  end
end
