require 'set'

class SentenceBreakIterator
  DEFAULT_STOP_WORDS_FILE = 'conf/stopwords.txt'

  def self.get_stopwords(stopwords_path = nil)
    @@stopwords ||= SentenceBreakIterator.load_stopwords(stopwords_path || DEFAULT_STOP_WORDS_FILE)
  end

  def initialize(paragraph)
    get_stopwords
    @paragraph = paragraph
    @paragraph_length = paragraph.length
    @next_index = 0
  end

  def next_sentence
    l = @next_index

    while l < @paragraph_length and get_stopwords.include?(@paragraph[l])
      l += 1
    end

    k = l + 1
    while k < @paragraph_length and not get_stopwords.include?(@paragraph[k])
      k += 1
    end

    # @paragraph[k] is stop words or k is paragraph_length
    @position = l
    @next_index = k
    if l < @paragraph_length
      return @paragraph[l..k-1]
    else
      return nil
    end
  end

  def get_posistion
    @position
  end

  private

  def self.load_stopwords(stopwords_path)
    stopwords = Set.new
    File.readlines(stopwords_path).each do |line|
      comment_index = line.index('//')
      next if comment_index == 0
      line = line[0..comment_index-1] if comment_index and comment_index > 0

      line.length.times do |i|
        stopwords << line[i]
      end
    end
    stopwords
  end

  def get_stopwords(stopwords_path = nil)
    SentenceBreakIterator.get_stopwords(stopwords_path)
  end
end
