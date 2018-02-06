require 'trie'
require 'dag'
require 'dag_dfs'
require 'date'
require 'hmm'
require 'sentence_break_iterator'

SEARCH_SEGMENT_MODE = 1
INDEX_SEGMENT_MODE = 2

class Segmenter

  def initialize(args = {})
    @segment_mode = args[:segment_mode] || SEARCH_SEGMENT_MODE
    @enable_hmm = args[:enable_hmm]
    @trie = load_dict_trie

    if @enable_hmm
      @hmm = Hmm.new
    end
  end

  def process(paragraph)
    tokens = []
    sentence_break_iterator = SentenceBreakIterator.new(paragraph)
    while true
      sentence = sentence_break_iterator.next_sentence
      break unless sentence
      tokens += process_sentence(sentence, sentence_break_iterator.get_posistion)
    end

    tokens
  end

  def process_sentence(sentence, sentence_offset)
    dag = create_dag(sentence)
    dfs = DagDfs.new(dag, @dict)

    if @segment_mode == SEARCH_SEGMENT_MODE
      max_path = dfs.find_max
      tokens = generate_tokens_from_path(max_path, sentence, sentence_offset)
    else
      tokens = generate_tokens_from_dag(dag, sentence, sentence_offset)
    end

    process_sentence_with_hmm(sentence, sentence_offset, tokens) if @enable_hmm
    tokens
  end

  private

  def process_sentence_with_hmm(sentence, sentence_offset, tokens)
    hmm_tokens = @hmm.process_sentence(sentence, sentence_offset)
    hmm_tokens.each do |token|
      if not tokens.include?(token)
        tokens << token
      end
    end
  end

  def create_dag(sentence)
    dag = Dag.new(sentence)
    sentence.length.times.each do |i|
      create_dag_substring(dag, sentence[i..-1], i)
    end

    return dag
  end

  def create_dag_substring(dag, str, sentence_offset)
    node = @trie.get_root
    str.length.times.each do |i|
      node = node.find_son(str[i])
      break unless node

      if node.is_word
        dag.add_link(sentence_offset, sentence_offset + i + 1) if i > 0
      end
    end
  end

  def load_dict_trie
    @dict ||= load_dict

    trie = Trie.new
    @dict.each do |word, freq|
      trie.add_word(word, freq)
    end
    trie
  end

  def load_dict
    dict = {}
    File.readlines('conf/sougou.dict').each do |line|
      word, freq_string = line.strip.split /[ \t]+/
      dict[word] = freq_string.to_i
    end
    dict
  end

  # This takes 10% processing time.
  def generate_tokens_from_path(max_path, sentence, sentence_offset)
    tokens = []
    (max_path.length - 1).times do |i|
      start_index = max_path[i]
      end_index = max_path[i+1] - 1
      tokens << [ sentence[start_index..end_index], sentence_offset + start_index ]
    end

    tokens
  end

  def generate_tokens_from_dag(dag, sentence, sentence_offset)
    tokens = []
    dag.end_of_path.times do |i|
      links = dag.get_link(i)
      links.each do |end_link|
        end_index = end_link - 1
        tokens << [ sentence[i..end_index], sentence_offset + i ]
      end
    end

    tokens
  end
end
