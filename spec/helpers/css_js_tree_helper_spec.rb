require 'spec_helper'

describe CssJsTreeHelper do

  it 'should be true' do
    true.should == true
  end

  before(:each) do
    Rails.cache.clear
    self.stubs(:action_name).returns('foo')
    self.stubs(:content_for).returns( ActiveSupport::SafeBuffer.new)
  end

  it "css_tree returns the correct value" do
    File.stubs(:exists?).returns(false)
    File.expects(:exists?).with(File.join(Rails.root,'public','stylesheets', 'action_view.css')).returns(true)
    File.expects(:exists?).with(File.join(Rails.root,'public','stylesheets', 'action_view', 'test_case', 'test', 'foo.css')).returns(true)

    assert_equal css_tree, '<link href="/stylesheets/action_view.css" media="screen" rel="stylesheet" type="text/css" />
<link href="/stylesheets/action_view/test_case/test/foo.css" media="screen" rel="stylesheet" type="text/css" />'
  end

  it "js_tree returns the correct values" do
    File.stubs(:exists?).returns(false)
    File.expects(:exists?).with(File.join(Rails.root,'public','javascripts', 'action_view.js')).returns(true)
    File.expects(:exists?).with(File.join(Rails.root,'public','javascripts', 'action_view', 'test_case', 'test', 'foo.js')).returns(true)

    assert_equal js_tree, '<script src="/javascripts/action_view.js" type="text/javascript"></script>
<script src="/javascripts/action_view/test_case/test/foo.js" type="text/javascript"></script>'

  end

  it 'partial css and js get pulled in' do
    File.stubs(:exists?).returns(false)
    File.expects(:exists?).times(1).with(File.join(Rails.root,'public','stylesheets', '_test.css')).returns(true)
    File.expects(:exists?).times(1).with(File.join(Rails.root,'public','javascripts', '_test.js')).returns(true)

    render :partial => '/test'
    render :partial => '/test'

    assert_equal css_tree, '<link href="/stylesheets/_test.css" media="screen" rel="stylesheet" type="text/css" />'
    assert_equal js_tree, '<script src="/javascripts/_test.js" type="text/javascript"></script>'
  end

  it 'cache prefix config change' do
    File.stubs(:exists?).returns(false)
    File.expects(:exists?).with(File.join(Rails.root,'public','stylesheets', 'action_view.css')).returns(true)
    css_tree
    assert Rails.cache.exist?("css_js_tree_css_action_view/test_case/test/foo")
    Rails.cache.clear
    assert(!Rails.cache.exist?("css_js_tree_css_action_view/test_case/test/foo"))

    CssJsTree.config[:cache_prefix] = 'foo_'
    css_tree
    assert Rails.cache.exist?("foo_css_action_view/test_case/test/foo")
  end




end