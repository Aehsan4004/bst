# main.rb

require_relative 'bst'

# Create a BST with 15 random numbers
array = Array.new(15) { rand(1..100) }
tree = Tree.new(array)

puts "Initial Tree:"
tree.pretty_print
puts "Is balanced? #{tree.balanced?}"

# Print traversals
puts "\nTraversals:"
puts "Level order: #{tree.level_order.inspect}"
puts "Preorder: #{tree.preorder.inspect}"
puts "Postorder: #{tree.postorder.inspect}"
puts "Inorder: #{tree.inorder.inspect}"

# Unbalance the tree
puts "\nUnbalancing the tree by adding numbers > 100:"
tree.insert(150)
tree.insert(200)
tree.insert(300)
tree.pretty_print
puts "Is balanced? #{tree.balanced?}"

# Rebalance the tree
puts "\nRebalancing the tree:"
tree.rebalance
tree.pretty_print
puts "Is balanced? #{tree.balanced?}"

# Print traversals again
puts "\nTraversals after rebalance:"
puts "Level order: #{tree.level_order.inspect}"
puts "Preorder: #{tree.preorder.inspect}"
puts "Postorder: #{tree.postorder.inspect}"
puts "Inorder: #{tree.inorder.inspect}"