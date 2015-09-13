require 'test/unit'
require './tokenizer'
class TokenizerTest < Test::Unit::TestCase
  def test_empty
    assert_equal(tokenize(""), [])
  end
  def test_one_token
    assert_equal(tokenize("foo"), ["foo"])
  end
  def test_two_token
    assert_equal(tokenize("foo bar"), ["foo", "bar"])
  end
  def test_semicolon
    assert_equal(tokenize("foo; bar;"), ["foo", ";", "bar", ";"])
  end
  def test_quotation
    assert_equal(tokenize("\"hoge\";"), ["\"hoge\"", ";"])
  end
  def test_brackets
    assert_equal(tokenize("()"), ["(", ")"])
  end
  def test_brackets2
    assert_equal(tokenize("(hoge)"), ["(", "hoge", ")"])
  end
end
