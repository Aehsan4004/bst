# bst.rb

# Node class with Comparable module
class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  def <=>(other)
    return nil unless other.is_a?(Node)
    @data <=> other.data
  end
end

# Tree class for managing the BST
class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array)
  end

  # Builds a balanced BST from an array
  def build_tree(array)
    # Remove duplicates and sort
    sorted_unique = array.uniq.sort
    return nil if sorted_unique.empty?
    mid = sorted_unique.length / 2
    root = Node.new(sorted_unique[mid])
    root.left = build_tree(sorted_unique[0...mid])
    root.right = build_tree(sorted_unique[mid + 1..-1])
    root
  end

  # Inserts a value into the tree
  def insert(value, node = @root)
    return @root = Node.new(value) if @root.nil?
    return if value == node.data  # No duplicates

    if value < node.data
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    else
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    end
  end

  # Deletes a value from the tree
  def delete(value, node = @root)
    return nil if node.nil?

    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      # Node to delete found
      if node.left.nil?
        return node.right
      elsif node.right.nil?
        return node.left
      else
        # Node has two children
        successor = min_value_node(node.right)
        node.data = successor.data
        node.right = delete(successor.data, node.right)
      end
    end
    node
  end

  # Finds the node with the minimum value in a subtree
  def min_value_node(node)
    current = node
    current = current.left while current.left
    current
  end

  # Finds a node with the given value
  def find(value, node = @root)
    return nil if node.nil?
    return node if node.data == value
    value < node.data ? find(value, node.left) : find(value, node.right)
  end

  # Level-order traversal (breadth-first)
  def level_order
    return [] if @root.nil?
    queue = [@root]
    result = []
    
    if block_given?
      while !queue.empty?
        node = queue.shift
        yield node
        queue << node.left if node.left
        queue << node.right if node.right
      end
    else
      while !queue.empty?
        node = queue.shift
        result << node.data
        queue << node.left if node.left
        queue << node.right if node.right
      end
      result
    end
  end

  # Inorder traversal (depth-first: left, root, right)
  def inorder(node = @root, result = [], &block)
    return result if node.nil?
    inorder(node.left, result, &block)
    block_given? ? yield(node) : result << node.data
    inorder(node.right, result, &block)
    result unless block_given?
  end

  # Preorder traversal (depth-first: root, left, right)
  def preorder(node = @root, result = [], &block)
    return result if node.nil?
    block_given? ? yield(node) : result << node.data
    preorder(node.left, result, &block)
    preorder(node.right, result, &block)
    result unless block_given?
  end

  # Postorder traversal (depth-first: left, right, root)
  def postorder(node = @root, result = [], &block)
    return result if node.nil?
    postorder(node.left, result, &block)
    postorder(node.right, result, &block)
    block_given? ? yield(node) : result << node.data
    result unless block_given?
  end

  # Returns the height of a node
  def height(node = @root)
    return -1 if node.nil?  # Leaf nodes have height 0, so parent is -1
    [height(node.left), height(node.right)].max + 1
  end

  # Returns the depth of a node
  def depth(target_node, node = @root, current_depth = 0)
    return -1 if node.nil? || target_node.nil?
    return current_depth if node == target_node
    if target_node.data < node.data
      depth(target_node, node.left, current_depth + 1)
    else
      depth(target_node, node.right, current_depth + 1)
    end
  end

  # Checks if the tree is balanced
  def balanced?(node = @root)
    return true if node.nil?
    left_height = height(node.left)
    right_height = height(node.right)
    (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)
  end

  # Rebalances the tree
  def rebalance
    values = inorder  # Get sorted array of values
    @root = build_tree(values)
  end

  # Pretty print method for visualization
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end