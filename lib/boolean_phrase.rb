require 'active_support/all'

class BooleanPhrase
  attr_reader :and_not_array, :and_arrays

  def initialize(and_not_array: [], and_arrays:[])
    @and_not_array = and_not_array
    @and_arrays = and_arrays.map { |and_array| { or: and_array } }
  end

  def phrase
    if and_not_array.length >= 1
      {and_not: [ and_phrase, { or: and_not_array } ]}
    elsif and_not_array.length == 0
      and_phrase
    end

  end

  def to_s
    phrase.to_s
  end

  private

  def and_phrase
    if and_arrays.length == 0
      {}
    elsif and_arrays.length == 1
      and_arrays[0]
    elsif and_arrays.length >= 2
      { and: and_arrays }
    end
  end
end