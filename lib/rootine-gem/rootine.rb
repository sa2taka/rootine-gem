# frozen_string_literal: true

require 'csv'

module RootineGem
  #
  # Root Explorer
  #
  class Rootine
    attr_reader :roots, :suffixes
    #
    # Rootine initializer
    # Specify an argument when using information other than standard
    #
    # @param [Array<Array<string>>] roots roots info.
    # @param [Array<Array<string>>] suffixes suffiex info.
    #
    def initialize(roots: nil, suffixes: nil)
      @roots = roots || CSV.read(File.expand_path('roots_data/roots.csv', __dir__))
      @suffixes = suffixes || CSV.read(File.expand_path('roots_data/suffixes.csv', __dir__))
    end

    #
    # Get roots from given word
    # Return value format:
    #   [
    #     [start, end, [regexp_i1, regexp_i2, ...]],
    #     [start, end, [regexp_i1, regexp_i2, ...]],
    #     ...
    #   ]
    #
    # @param [String] word word finded roots
    # @return [Array] finded roots(the longest of)
    #
    def get_word_roots(word)
      raise ArgumentError, 'Word must be greater than 0 characters' if word.length.zero?

      roots = []
      suffixes = find_suffixes(word)

      suffixes.each do |suffix|
        work_word = word[0..suffix[0]]
        roots << find_roots(work_word).append(suffix)
      end

      return nil if roots.length.zero?
      return roots[0] if roots.length == 1

      result = []
      longest = 0

      roots.each do |root|
        pp root
        root_length = root.inject { |sum, r| sum + (r[1] - r[0]) }
        if root_length > longest
          result = root
          longest = root_length
        end
      end

      result
    end

    private

    #
    # Find roots from given word.
    # Return value format:
    #   [
    #     [start, end, [regexp_i1, regexp_i2, ...]],
    #     [start, end, [regexp_i1, regexp_i2, ...]],
    #     ...
    #   ]
    #
    # @param [String] word word finded roots
    #
    # @return [Array] finded roots(the longest of)
    #
    def find_roots(word)
      result = []
      i = 0
      while i < word.length
        work_word = word[i..-1]
        matched_regexps = []
        root_regexps.each_with_index do |regexp_str, regexp_i|
          regexp = Regexp.new(regexp_str)
          if (matched = regexp.match(work_word))
            matched_regexps << [i + matched.begin(0), i + matched.end(0), regexp_i]
          end
        end

        if matched_regexps.length.zero?
          i += 1
        else
          longest_start, longest_end, = (matched_regexps.sort_by { |r| r[1] }).reverse[0]
          longets_regexp_indexes = matched_regexps
                                   .filter { |matched| longest_start == matched[0] && longest_end == matched[1] }
                                   .map { |matched| matched[2] }
          diff = (longest_end - longest_start).abs
          if diff >= 3 || i.zero?
            result.append([longest_start, longest_end, longets_regexp_indexes])
          end
          i += diff
        end
      end

      result
    end

    #
    # Find allsuffix from given word.
    # Return value format:
    #   [
    #     [start, end, [regexp_i1, regexp_i2]],
    #     [start, end, [regexp_i1, regexp_i2]],
    #     ...
    #   ]
    #
    # @param [String] word word finded roots
    #
    # @return [Array] finded roots(the longest of)
    #
    def find_suffixes(word)
      matched_regexps = []
      result = []
      suffix_regexps.each_with_index do |regexp_str, regexp_i|
        regexp = Regexp.new(regexp_str)
        if (matched = regexp.match(word))
          matched_regexps << [matched.begin(0), matched.end(0), regexp_i]
        end
      end

      unless matched_regexps.length.zero?
        matched_regexps.sort_by! { |matched| matched[1] }
        matched_regexps.sort_by! { |matched| matched[0] }
        work_indexs = []
        pre_start = pre_end = nil
        matched_regexps.each do |matched|
          if pre_start != matched[0] || pre_end != matched[1]
            result << [pre_start, pre_end, work_indexs] unless pre_start.nil?
            work_indexs = []
            pre_start = matched[0]
            pre_end = matched[1]
            work_indexs << matched[2]
          else
            work_indexs << matched[2]
          end
        end
        result << [pre_start, pre_end, work_indexs]
      end

      result
    end

    def root_regexps
      roots.map { |r| r[0] }
    end

    def suffix_regexps
      suffixes.map { |s| s[0] }
    end
  end
end
