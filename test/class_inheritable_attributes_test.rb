require 'test/unit'
require 'mocha'

require 'class_inheritable_attributes'

class ClassInheritableAttributesTest < Test::Unit::TestCase
  def setup
    @class = Class.new { class_inheritable_attr_accessor :foo }
  end
  
  def test_initial_value
    assert_equal nil, @class.foo
  end
  
  def test_thread_overrideability
    @class.foo = :bar
    assert_equal :over, Thread.new { @class.foo = :over; @class.foo }.value
    assert_equal :bar, @class.foo
  end
  
  def test_inheritability
    child = Class.new(@class)
    
    @class.foo = :bar
    assert_equal :bar, child.foo
    
    child.foo = :other
    assert_equal :other, child.foo
    assert_equal :bar, @class.foo
    
    assert_equal :in_thread, Thread.new { child.foo = :in_thread; child.foo }.value
    assert_equal :other, child.foo
    assert_equal :bar, @class.foo
    
    @class.foo = :changed
    assert_equal :other, child.foo
    assert_equal :changed, @class.foo
  end
  
  def test_housekeeping
    Thread.new do
      assert_equal 0, ClassInheritableAttributes.instance_eval { registry }.size
      @class.foo = nil
      assert_equal 0, ClassInheritableAttributes.instance_eval { registry }.size
      @class.foo = :bar
      assert_equal 1, ClassInheritableAttributes.instance_eval { registry }.size
      @class.foo = nil
      assert_equal 0, ClassInheritableAttributes.instance_eval { registry }.size
    end.join
  end
  
  def test_attribute_methods_are_defined_in_ancestors
    c = @class
    def c.foo
      super || :default
    end
    
    assert_equal :default, c.foo
    
    c.foo = :explicit
    assert_equal :explicit, c.foo
  end
end
