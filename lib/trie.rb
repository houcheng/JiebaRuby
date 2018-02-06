require 'pp'

class TrieNode
  def add_son(ch)
    @sons = {} unless @sons
    return @sons[ch] if @sons[ch]

    son_node = TrieNode.new
    @sons[ch] = son_node
  end

  def find_son(ch)
    return nil unless @sons
    return @sons[ch]
  end

  def set_freq(freq)
    @freq = freq
  end

  def get_freq
    @freq
  end

  def is_word
    @freq != nil
  end

  def dump(indent = 0)
    return unless @sons
    @sons.each do |k, v|
      print('  '* indent)
      print("key: #{k}\n")
      v.dump(indent + 2)
    end
    print("The FREQUENCY IS: #{@freq}\n")
  end
end

class Trie
  def initialize
    @root = TrieNode.new
  end

  def get_root
    @root
  end

  def add_word(word, freq)
    node = @root
    word.length.times.each do |i|
      node = node.add_son(word[i])
    end
    node.set_freq(freq)
  end

  def match_word(word)
    node = @root
    word.length.times.each do |i|
      node = node.find_son(word[i])
      return nil unless node
    end
    node.get_freq
  end

  def dump
    @root.dump
  end
end
