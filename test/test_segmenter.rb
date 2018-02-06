require "minitest/autorun"
require 'helper'

TEST_TEXTS = [
  '到此为止我们已经获得了有向无环图做媳妇，下一步计算出最大可能的阿迪阿丁路径阿豆。。。。。。路径',
  '然後沿著邊隨意走訪任何一個狀態'
]

class TestSegmenter < Minitest::Test
  def test_segmenter_in_index_mode
    segmenter = Segmenter.new segment_mode: INDEX_SEGMENT_MODE, enable_hmm: false
    results = segmenter.process(TEST_TEXTS[0])
    assert_includes(results, ['阿迪', 31])
    assert_includes(results, ['阿丁', 33])
    assert_includes(results, ['阿豆', 37])

    results = segmenter.process(TEST_TEXTS[1])
    assert_includes(results, ['沿著', 2])
  end

  def test_segmenter_in_search_mode
    segmenter = Segmenter.new segment_mode: SEARCH_SEGMENT_MODE, enable_hmm: false

    results = segmenter.process(TEST_TEXTS[0])
    assert_includes(results, ['阿迪', 31])
    assert_includes(results, ['阿丁', 33])
    assert_includes(results, ['阿豆', 37])

    results = segmenter.process(TEST_TEXTS[1])
    assert_includes(results, ['沿著', 2])
  end

  def test_segmenter_with_hmm
    segmenter = Segmenter.new segment_mode: SEARCH_SEGMENT_MODE, enable_hmm: true
    results = segmenter.process(TEST_TEXTS[1])
    assert_includes(results, ["隨意", 5])
    assert_includes(results, ["走訪", 7])
    assert_includes(results, ["任何", 9])
    assert_includes(results, ["一個", 11])
  end
end
