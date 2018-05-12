require_relative '../test_helper'
require_relative '../lib/boolean_phrase'

# { verb: [] }
# { verb: ['foo']}
# { verb: ['foo1', 'foo2']}
# { verb: ['foo1', 'foo2', 'foo3']}
# { and_not: [ { and: ['foo1', 'foo2', 'foo3']}, 'bar1' ] }
# { and_not: [ {and: [ {or: []}, {or: []}  ]}, 'bar1' ] }
#
# { and: [{ or: ['FOO-5', 'FOO-43'] }, { or: ['FOO-2', 'FOO-3'] }] }
# { and: [{or: ['FOO-5', 'FOO-43']},{and: [{ or: ['FOO-5', 'FOO-43'] }, { or: ['FOO-2', 'FOO-3'] }]}] }

class BooleanPhraseTest < Minitest::Test

  def test_build_a_BooleanPhrase
    actual = BooleanPhrase.new(and_arrays:[], and_not_array:[])
    assert_kind_of BooleanPhrase, actual
  end

  def test_has_arrays_setup
    job_titles_array = ['jt1', 'jt2', 'jt3']
    industries_array = ['ind1', 'ind2', 'ind3']
    fraud_array = ['f1', 'f2']
    my_boolean_phrase = BooleanPhrase.new(
      and_arrays:[job_titles_array, industries_array],
      and_not_array:fraud_array
    )
    assert_kind_of Array, my_boolean_phrase.and_arrays, [job_titles_array, industries_array]
    assert_kind_of Array, my_boolean_phrase.and_not_array
  end

  def test_phrase_returns_hash
    actual = BooleanPhrase.new.phrase
    assert_kind_of Hash, actual
  end


  def test_one_item
    job_titles_array = ['jt1', 'jt2', 'jt3']
    expected = {or: ['jt1', 'jt2', 'jt3']}
    fraud_array = []
    actual = BooleanPhrase.new(
      and_arrays:[job_titles_array],
      and_not_array:fraud_array
    ).phrase
    assert_equal(expected, actual)
  end

  def test_two_items
    job_titles_array = ['jt1', 'jt2', 'jt3']
    industries_array = ['ind1', 'ind2', 'ind3']
    fraud_array = []
    expected = {and: [{or: ['jt1', 'jt2', 'jt3']} , {or: ['ind1', 'ind2', 'ind3']}] }
    actual = BooleanPhrase.new(
      and_arrays:[job_titles_array, industries_array],
      and_not_array:fraud_array
    ).phrase
    assert_equal(expected, actual)
  end

  def test_three_items
    #
    job_titles_array = ['jt1', 'jt2', 'jt3']
    industries_array = ['ind1', 'ind2', 'ind3']
    brand_safety_array = ['bs1', 'bs2', 'bs3']
    fraud_array = []
    expected = {and: [{or: ['jt1', 'jt2', 'jt3']} , {or: ['ind1', 'ind2', 'ind3']}, {or: ['bs1', 'bs2', 'bs3']}] }
    actual = BooleanPhrase.new(
      and_arrays:[job_titles_array, industries_array, brand_safety_array],
      and_not_array:fraud_array
    ).phrase
    assert_equal(expected, actual)
  end

  def test_three_items_with_negated_item
    job_titles_array = ['jt1', 'jt2']
    industries_array = ['ind1', 'ind2']
    brand_safety_array = ['bs1', 'bs2']
    fraud_array = ['f1', 'f2']
    expected = {and_not: [{and: [{or: ['jt1', 'jt2']}, {or: ['ind1', 'ind2']}, {or: ['bs1', 'bs2']}] }, {or: ['f1', 'f2']}]}
    actual = BooleanPhrase.new(
      and_not_array: fraud_array,
      and_arrays: [
        job_titles_array,
        industries_array,
        brand_safety_array
      ]
    ).phrase
    assert_equal(expected, actual)
  end


end

