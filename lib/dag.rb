class Dag
  def initialize(sentence)
    @sentence = sentence
    # links[i] = [j, k, m]
    @links = {}
    @end_of_path = @sentence.length
    @sentence.length.times.each do |i|
      @links[i] = [ i + 1 ]
    end
  end

  def end_of_path
    @end_of_path
  end

  def add_link(i, j)
    @links[i].push(j)
  end

  def get_link(i)
    @links[i]
  end

  def get_word(i, j)
    @sentence[i..j-1]
  end
end
