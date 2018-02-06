require "minitest/autorun"
require 'helper'

class TestHmm < Minitest::Test
  def setup
    @hmm = Hmm.new
  end

  def test_jieba_hmm1
    results = @hmm.process('到此为止我们已经获得了有向无环图')
    assert_includes results, ["为止", 2]
    assert_includes results, ["我们", 4]
    assert_includes results, ["已经", 6]
    assert_includes results, ["获得", 8]
  end

  def test_jieba_hmm2
    results = @hmm.process('下一步计算出最大可能的路径')
    assert_includes results, ["下一步", 0]
    assert_includes results, ["计算出", 3]
    assert_includes results, ["最大", 6]
    assert_includes results, ["可能", 8]
  end

  def test_jieba_hmm3
    results = @hmm.process('然後沿著邊隨意走訪任何一個狀態')
    assert_includes results, ["然後沿", 0]
    assert_includes results, ["著邊", 3]
    assert_includes results, ["隨意", 5]
    assert_includes results, ["走訪", 7]
    assert_includes results, ["任何", 9]
    assert_includes results, ["一個", 11]
  end
end
