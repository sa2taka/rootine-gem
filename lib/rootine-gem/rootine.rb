# frozen_string_literal: true

module RootineGem
  #
  # Root Explorer
  #
  class Rootine
    #
    # Rootine initializer
    # Specify an argument when using information other than standard
    #
    # @param [Array<Array<string>>] roots roots info.
    # @param [Array<Array<string>>] suffixes suffiex info.
    #
    def initialize(roots: nil, suffixes: nil)
      @roots = roots || CSV.read(File.expand_path('../roots_data/roots.csv', __dir__))
      @suffixes = suffixes || CSV.read(File.expand_path('../roots_data/suffixes.csv', __dir__))
    end
  end
end
