class Meme
  def i_can_has_cheezburger?
    "OHAI!"
  end

  def will_it_blend?
    "YES!"
  end
end

class MemeAsker
  def initialize(meme)
    @meme = meme
  end

  def ask(question)
    method = question.tr(" ", "_") + "?"
    @meme.__send__(method)
  end
end

require "minitest/autorun"

class TestMemeAsker < Minitest::Test
  def test_asks_unpunctuated_question_mock
    @meme = Minitest::Mock.new
    @meme_asker = MemeAsker.new(@meme)
    @meme.expect(:will_it_blend?, :return_value)

    @meme_asker.ask("will it blend")

    @meme.verify
  end

  def test_asks_unpunctuated_question_stub_with_block
    @meme = Meme.new
    @meme.stub(:will_it_blend?, :not_this_time) do
      result = MemeAsker.new(@meme).ask("will it blend")
      assert_equal :not_this_time, result
    end
  end

  def test_asks_unpunctuated_question_stub_with_singleton_method
    meme = Meme.new
    def meme.will_it_blend?; :no; end

    result = MemeAsker.new(meme).ask("will it blend")

    assert_equal :no, result
  end
end
