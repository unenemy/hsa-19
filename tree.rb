class Node
  attr_accessor :value, :left, :right, :height

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
    @height = 1
  end
end

class AVLTree
  def initialize
    @root = nil
  end

  def add(value)
    @root = add_recursive(@root, value)
  end

  def find(value)
    find_recursive(@root, value)
  end

  def remove(value)
    @root = remove_recursive(@root, value)
  end

  private

  def height(node)
    node&.height || 0
  end

  def update_height(node)
    node.height = 1 + [height(node.left), height(node.right)].max
  end

  def balance_factor(node)
    height(node.left) - height(node.right)
  end

  def rotate_right(y)
    x = y.left
    t = x.right

    x.right = y
    y.left = t

    update_height(y)
    update_height(x)

    x
  end

  def rotate_left(x)
    y = x.right
    t = y.left

    y.left = x
    x.right = t

    update_height(x)
    update_height(y)

    y
  end

  def add_recursive(node, value)
    return Node.new(value) if node.nil?

    if value < node.value
      node.left = add_recursive(node.left, value)
    elsif value > node.value
      node.right = add_recursive(node.right, value)
    else
      return node # Duplicate values not allowed
    end

    update_height(node)

    balance = balance_factor(node)

    # Left Heavy
    if balance > 1
      if value < node.left.value
        return rotate_right(node)
      else
        node.left = rotate_left(node.left)
        return rotate_right(node)
      end
    end

    # Right Heavy
    if balance < -1
      if value > node.right.value
        return rotate_left(node)
      else
        node.right = rotate_right(node.right)
        return rotate_left(node)
      end
    end

    node
  end

  def find_recursive(node, value)
    return nil if node.nil?
    return node if node.value == value

    if value < node.value
      find_recursive(node.left, value)
    else
      find_recursive(node.right, value)
    end
  end

  def remove_recursive(node, value)
    return nil if node.nil?

    if value < node.value
      node.left = remove_recursive(node.left, value)
    elsif value > node.value
      node.right = remove_recursive(node.right, value)
    else
      # Node to be deleted found

      # Case 1: Node with only one child or no child
      if node.left.nil?
        return node.right
      elsif node.right.nil?
        return node.left
      end

      # Case 2: Node with two children
      node.value = find_min_value(node.right).value
      node.right = remove_recursive(node.right, node.value)
    end

    update_height(node)

    balance = balance_factor(node)

    # Left Heavy
    if balance > 1
      if balance_factor(node.left) >= 0
        return rotate_right(node)
      else
        node.left = rotate_left(node.left)
        return rotate_right(node)
      end
    end

    # Right Heavy
    if balance < -1
      if balance_factor(node.right) <= 0
        return rotate_left(node)
      else
        node.right = rotate_right(node.right)
        return rotate_left(node)
      end
    end

    node
  end

  def find_min_value(node)
    current = node
    current = current.left until current.left.nil?
    current
  end
end
