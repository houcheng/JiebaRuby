require 'nmatrix'
require 'pp'

module HmmParameters

  LOG_ZERO = -3.14e+100

  STATE_B = 0
  STATE_E = 1
  STATE_M = 2
  STATE_S = 3

  # B, E, M, S
  I = NMatrix[ [ -0.26268660809250016 ],
               [ LOG_ZERO             ],
               [ LOG_ZERO             ],
               [ -1.4652633398537678  ] ]

  # CPT for B/E/M/S
  # ROW(i): state(i) to s*
  A = NMatrix[
      [ LOG_ZERO, -0.510825623765990,  -0.916290731874155, LOG_ZERO ],  # B to others
      [ -0.5897149736854513, LOG_ZERO, LOG_ZERO, -0.8085250474669937  ],  # E to others
      [ LOG_ZERO, -0.33344856811948514, -1.2603623820268226, LOG_ZERO ],  # M to others
      [ -0.7211965654669841, LOG_ZERO, LOG_ZERO, -0.6658631448798212  ]   # S to others
  ]

  # Emit probability: B/E/M/S
  STATE_NAMES = 'BEMS'
  B = [ {}, {}, {}, {} ]

  def getStateIndex(ch)
    case ch
    when 'B'
      return 0
    when 'E'
      return 1
    when 'M'
      return 2
    when 'S'
      return 3
    end

    throw "Invalid state char: #{ch}."
  end

  def get_verbose_states(states)
    state_names = ''
    states.length.times do |i|
      next unless states[i]
      state_names += STATE_NAMES[states[i]]
    end
    state_names
  end


  def load_emit_prob
    index = 0
    File.readlines('conf/prob_emit.txt').each do |line|
      if line[0] >= 'A' and line[0] <= 'Z'
        index = getStateIndex(line[0])
        next
      end

      word, prob_string = line.split("\t")
      prob = prob_string.to_f
      B[index][word] = prob
    end
  end

  def get_emit_prob(i, sym)
    if B[i][sym] == nil
      return LOG_ZERO
    end
    return B[i][sym]
  end
end
