# There are many ways to implement these methods, feel free to add arguments
# to methods as you see fit, or to create helper methods.
require_relative "bst_node"

class BinarySearchTree
  attr_reader :root
  attr_accessor :left, :right

  def initialize(root = nil)
    @root = root
  end

  def insert(value, tree_node = root)
    unless root
      @root = BSTNode.new(value)
      return value
    end

    pointer = value > tree_node.value ? :@right : :@left
    child = tree_node.instance_variable_get(pointer)

    return insert(value, child) if child

    node = BSTNode.new(value)
    tree_node.instance_variable_set(pointer, node)
    node.parent = tree_node

    value
  end

  def find(value, tree_node = root)
    return nil unless tree_node

    case value <=> tree_node.value
    when 0
      tree_node
    when -1
      find(value, tree_node.left)
    when 1
      find(value, tree_node.right)
    end
  end

  def delete(value)
    node = find(value)
    return false unless node

    delete_node(node)
  end

  # helper method for #delete:
  def maximum(tree_node = @root)
    tree_node.right ? maximum(tree_node.right) : tree_node
  end

  def depth(tree_node = @root, depth = 0)
    return depth == 0 ? 0 : depth - 1 if !tree_node

    left_depth = depth(tree_node.left, depth + 1)
    right_depth = depth(tree_node.right, depth + 1)

    return left_depth > right_depth ? left_depth : right_depth
  end

  def is_balanced?(tree_node = @root)
    return true if !tree_node
    difference = (depth(tree_node.left) - depth(tree_node.right)).abs
    difference.between?(0, 1) && is_balanced?(tree_node.left) && is_balanced?(tree_node.right)
  end

  def in_order_traversal(tree_node = @root, arr = [])
    in_order_traversal(tree_node.left, arr) if tree_node.left
    arr << tree_node.value
    in_order_traversal(tree_node.right, arr) if tree_node.right
    arr
  end


  private
  # optional helper methods go here:

  def get_pointer_from_parent(tree_node)
    parent = tree_node.parent
    return nil unless parent
    pointer = tree_node.value > parent.value ? :@right : :@left
  end

  def promote(old_node, new_node)
    pointer = get_pointer_from_parent(old_node)
    old_node.parent.instance_variable_set(pointer, new_node)
    new_node.parent = old_node.parent if new_node
  end

  def delete_node(node)
    replacement = replace(node)
    if !node.parent
      @root = replacement
    else
      promote(node, replacement)
    end
    true
  end

  def replace(node)
    left, right, parent = node.left, node.right, node.parent
    return nil unless left || right

    replacement = nil

    if left && right
      replacement = maximum(left)
      if replacement.left
        promote(replacement, replacement.left)
      end
    else
      replacement = left || right
    end

    replacement.right, replacement.left, replacement.parent = right, left, parent
    right.parent = replacement if right
    left.parent = replacement if left
    replacement
  end
end
