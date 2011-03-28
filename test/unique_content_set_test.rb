require File.expand_path("../../lib/unique_content_set", __FILE__)
require 'test/unit'
require 'rubygems'
require 'redis'

UniqueContentSet.redis = Redis.new
UniqueContentSet.redis.select ENV['REDIS_DB'] || 7

class UniqueContentSetTest < Test::Unit::TestCase
  def setup
    UniqueContentSet.redis.flushdb
    @set  = UniqueContentSet.new :abc
    @set.add 'abc', 1
  end

  def test_adding_unique_content
    assert_equal true, @set.add('def')
  end

  def test_adding_repeated_content
    assert_equal false, @set.add('abc')
  end

  def test_checking_content_existence
    assert  @set.exist?('abc')
    assert !@set.exist?('def')
  end

  def test_removing_old_content
    @set.add 'def', 2
    @set.add 'ghi', 3
    assert @set.exist?('abc')
    assert @set.exist?('def')
    assert @set.exist?('ghi')

    @set.delete_before(1)

    assert !@set.exist?('abc')
    assert !@set.exist?('def')
    assert  @set.exist?('ghi')
  end
end
