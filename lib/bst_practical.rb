require 'binary_search_tree'
require 'byebug'
def kth_largest(tree_node, k, idx = 0)
  idx = kth_largest(tree_node.right, k, idx) if tree_node.right
  return idx if idx.is_a? BSTNode
  idx += 1
  return tree_node if k === idx
  idx = kth_largest(tree_node.left, k, idx) if tree_node.left
  idx
end
