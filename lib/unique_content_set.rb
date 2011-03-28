require 'digest/sha1'

# Stores a set of unique content.  This is used to check if new content being
# added has been seen already.
class UniqueContentSet
  VERSION = '0.0.1'

  class << self
    # Sets are stored in Redis.
    attr_accessor :redis,

    # Prefix all Redis keys with a certain value.
      :redis_prefix
  end

  self.redis_prefix = "unique"

  attr_reader :key

  def initialize(*args)
    @redis = self.class.redis

    # Turn the given args into a redis key, with pieces separated by ':'.
    args.unshift self.class.redis_prefix
    args.compact!
    args.map! { |a| a.to_s }
    @key = args * ":"
  end

  # Public: Adds the given content to the current set, scored by the
  # given time.
  #
  # content - String content to add to the set.
  # time    - The current Time the content was created.
  #
  # Returns true if this is the first occurence of the content, or false.
  def add(content, time = Time.now)
    @redis.zadd(@key, time.to_i, member_from(content))
  end

  # Public: Looks for the given content in the current set.
  #
  # content - String content that is being checked.
  #
  # Returns true if the content is a member of the set, or false.
  def exist?(content)
    !!@redis.zscore(@key, member_from(content))
  end

  # Public: Removes content posted before the given time.
  #
  # time - The latest Time that should be purged from the set.
  #
  # Returns a Fixnum of the number of removed entries.
  def delete_before(time)
    @redis.zremrangebyscore(@key, 0, time.to_i+1)
  end

private
  # Encodes the content into a value that can be used to quickly check
  # uniqueness in the set.
  #
  # content - The String content.
  #
  # Returns a String of the the size of the content, plus a SHA of the content,
  # separated by a colon.
  def member_from(content)
    content = content.to_s
    '%d:%s' % [content.size, Digest::SHA1.hexdigest(content)]
  end
end
