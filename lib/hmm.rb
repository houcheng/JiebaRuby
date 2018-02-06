require 'nmatrix'
require 'pp'
require 'sentence_break_iterator'
require 'hmm_parameters'

class Hmm
  include HmmParameters

  def initialize
    load_emit_prob
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
    hmm_states = viterbi(sentence)
    generate_tokens_from_states(hmm_states, sentence, sentence_offset)
  end

  private

  def generate_tokens_from_states(states, sentence, sentence_offset)
    tokens = []

    prev_state = STATE_E
    pending = ''
    i = 0
    token_offset = 0

    # +------->E
    # |
    # B-->M--->E   S
    states.each do |state|
      if state == STATE_E
        tokens << [ pending + sentence[i], token_offset + sentence_offset ]
        token_offset = i + 1
        pending = ''
      elsif state == STATE_B or state == STATE_M
        pending += sentence[i]
      elsif state == STATE_S
        tokens << [ sentence[i], i + sentence_offset ]
        token_offset = i + 1
      end

      i += 1
    end

    tokens
  end

  def viterbi(symbols)
    # m, n = B.shape
    n = 4
    t = symbols.size

    states = NMatrix.new([n, t], 0)
    q_path = Array.new t
    data = NMatrix.new([n, t], LOG_ZERO)

    (0..n-1).each do |j|
      # data[j, 0] = I[j] * B[j][symbols[0]]
      data[j, 0] = I[j] + get_emit_prob(j, symbols[0])
    end

    # i: for time, i=0 for t1
    (1..t-1).each do |i|

      # j: is for state, j=0 is for s(1)
      (0..n-1).each do |j|

        (0..n-1).each do |si|
          # Note: the emitting function state should be j, not si
          # v = data[si, i-1] * A[si, j] * B[j][symbols[i]]
          v = data[si, i-1] + A[si, j] + get_emit_prob(j, symbols[i])
          if v > data[j, i]
            states[j, i] = si
            data[j, i] = v
          end
        end
      end
    end

    # find max prob state of time t data[*, t-1]
    (0..n-1).each do |j|
      max = LOG_ZERO
      if data[j, t-1] > max
        max = data[j, t-1]
        q_path[t-1] = j
      end
    end

    # back trace the path from the max prob state.
    i = t-2
    while i >= 0
      q_path[i] = states[q_path[i+1], i+1]
      i -= 1
    end
    q_path
  end
end
