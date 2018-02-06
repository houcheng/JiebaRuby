# Jieba Chinese Segmentation in Ruby

## Introduction

This project implements Jieba Chinese segmentation within Ruby gem. The implemented features includes:

- Supports Jieba segmentation with dictionary lookup algorithm
    - Line break iterator
    - Loads words into the dictionary trie
    - Build DAG and find all/ maximum segmentation compositions
    - Search mode and index mode segmentations
- Supports Jieba segmentation with HHM algorithm

## Usage example

```
> require 'jieba'
> segmenter = Segmenter.new segment_mode: SEARCH_SEGMENT_MODE, enable_hmm: true
> p(segmenter.process('然後沿著邊隨意走訪任何一個狀態'))
  [["然", 0], ["後", 1], ["沿著", 2], ["邊", 4], ["隨", 5], ["意", 6], ["走", 7], ["訪", 8], ["任", 9],
   ["何", 10], ["一", 11], ["個", 12], ["狀", 13], ["態", 14], ["然後沿", 0], ["著邊", 3], ["隨意", 5],
   ["走訪", 7], ["任何", 9], ["一個", 11]]

```

## TODO list

1. Add traditional Chinese dictionary
2. Find training data for building traditional chinese HMM probabilistic model.
