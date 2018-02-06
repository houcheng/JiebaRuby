class DagDfs
  def initialize(dag, dict)
    @dag = dag
    @dict = dict
  end

  def find_max
    @max_weight = 0
    @max_weight_path = []
    find_max_dfs(0, 0, [ 0 ])

    return @max_weight_path
  end

  def find_max_dfs(i, weight, path)
    if i == @dag.end_of_path
      check_max_path(weight, path)
      return
    end

    @dag.get_link(i).each do |j|
        word = @dag.get_word(i, j)
        if @dict[word]
          word_weight = @dict[word]
        else
          word_weight = 0
        end
        new_path = path.clone
        new_path << j
        find_max_dfs(j, weight + word_weight, new_path)
    end
    @max_weight_path
  end

  def check_max_path(weight, path)
    if weight > @max_weight
      @max_weight = weight
      @max_weight_path = path
    end
  end
end
