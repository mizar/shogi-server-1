$:.unshift File.join(File.dirname(__FILE__), "..")
require 'test/unit'
require 'shogi_server'
require 'shogi_server/player'
require 'shogi_server/login'
require 'shogi_server/handicapped_boards'

class ShogiServer::BasicPlayer
  attr_accessor :protocol
end


class TestLogin < Test::Unit::TestCase 
  def setup
    @p_csa = ShogiServer::BasicPlayer.new
    @p_csa.name = "hoge"
    @p_x1 = ShogiServer::BasicPlayer.new
    @p_x1.name = "hoge"
    @csa = ShogiServer::LoginCSA.new(@p_csa,"floodgate-900-0,xyz")
    @x1 = ShogiServer::Loginx1.new(@p_x1, "xyz")
  end

  def test_player_id
    assert(@p_x1.player_id == @p_csa.player_id)
  end

  def test_login_factory_x1
    player = ShogiServer::BasicPlayer.new
    player.name = "hoge"
    login = ShogiServer::Login::factory("LOGIN hoge xyz x1", player)
    assert_instance_of(ShogiServer::Loginx1, login)
    assert_equal("xyz", player.password)
    assert_equal(@p_x1.player_id, player.player_id)
  end

  def test_login_factory_csa
    player = ShogiServer::BasicPlayer.new
    player.name = "hoge"
    login = ShogiServer::Login::factory("LOGIN hoge floodagate-900-0,xyz", player)
    assert_instance_of(ShogiServer::LoginCSA, login)
    assert_equal("xyz", player.password)
    assert_equal(@p_csa.player_id, player.player_id)
    assert_equal("*", login.turn_preference)
  end

  def test_login_factory_csa_fischer
    player = ShogiServer::BasicPlayer.new
    player.name = "hoge"
    login = ShogiServer::Login::factory("LOGIN hoge floodagate-600-10F,xyz", player)
    assert_instance_of(ShogiServer::LoginCSA, login)
    assert_equal("xyz", player.password)
    assert_equal(@p_csa.player_id, player.player_id)
    assert_equal("*", login.turn_preference)
  end

  def test_login_factory_csa_no_gamename
    player = ShogiServer::BasicPlayer.new
    player.name = "hoge"
    login = ShogiServer::Login::factory("LOGIN hoge xyz", player)
    assert_instance_of(ShogiServer::LoginCSA, login)
    assert_equal("xyz", player.password)
    assert_equal(@p_csa.player_id, player.player_id)
    assert_equal("*", login.turn_preference)
    assert_equal(ShogiServer::Default_Game_Name, login.gamename)
  end

  def test_login_factory_csa_with_black
    player = ShogiServer::BasicPlayer.new
    player.name = "hoge"
    login = ShogiServer::Login::factory("LOGIN hoge floodgate-900-0-B,xyz", player)
    assert_instance_of(ShogiServer::LoginCSA, login)
    assert_equal("xyz", player.password)
    assert_equal(@p_csa.player_id, player.player_id)
    assert_equal("+", login.turn_preference)
    assert_equal("floodgate-900-0", login.gamename)
  end

  def test_login_factory_csa_with_black_fischer
    player = ShogiServer::BasicPlayer.new
    player.name = "hoge"
    login = ShogiServer::Login::factory("LOGIN hoge floodgate-900-10F-B,xyz", player)
    assert_instance_of(ShogiServer::LoginCSA, login)
    assert_equal("xyz", player.password)
    assert_equal(@p_csa.player_id, player.player_id)
    assert_equal("+", login.turn_preference)
    assert_equal("floodgate-900-10F", login.gamename)
  end

  def test_login_factory_csa_with_white
    player = ShogiServer::BasicPlayer.new
    player.name = "hoge"
    login = ShogiServer::Login::factory("LOGIN hoge floodgate-900-0-W,xyz", player)
    assert_instance_of(ShogiServer::LoginCSA, login)
    assert_equal("xyz", player.password)
    assert_equal(@p_csa.player_id, player.player_id)
    assert_equal("-", login.turn_preference)
    assert_equal("floodgate-900-0", login.gamename)
  end

  def test_login_factory_csa_with_white
    player = ShogiServer::BasicPlayer.new
    player.name = "hoge"
    login = ShogiServer::Login::factory("LOGIN hoge floodgate-900-10F-W,xyz", player)
    assert_instance_of(ShogiServer::LoginCSA, login)
    assert_equal("xyz", player.password)
    assert_equal(@p_csa.player_id, player.player_id)
    assert_equal("-", login.turn_preference)
    assert_equal("floodgate-900-10F", login.gamename)
  end

  def test_login_factory_csa_without_trip
    player = ShogiServer::BasicPlayer.new
    player.name = "hoge"
    login = ShogiServer::Login::factory("LOGIN hoge floodgate-900-0", player)
    assert_instance_of(ShogiServer::LoginCSA, login)
    assert_nil(player.password)
    assert_equal(nil, player.player_id)
    assert_equal("*", login.turn_preference)
    assert_equal("floodgate-900-0", login.gamename)
  end

  def test_login_factory_csa_without_trip_with_black
    player = ShogiServer::BasicPlayer.new
    player.name = "hoge"
    login = ShogiServer::Login::factory("LOGIN hoge floodgate-900-0-B", player)
    assert_instance_of(ShogiServer::LoginCSA, login)
    assert_nil(player.password)
    assert_equal(nil, player.player_id)
    assert_equal("+", login.turn_preference)
    assert_equal("floodgate-900-0", login.gamename)
  end

  def test_login_factory_csa_without_trip_with_white
    player = ShogiServer::BasicPlayer.new
    player.name = "hoge"
    login = ShogiServer::Login::factory("LOGIN hoge floodgate-900-0-W", player)
    assert_instance_of(ShogiServer::LoginCSA, login)
    assert_nil(player.password)
    assert_equal(nil, player.player_id)
    assert_equal("-", login.turn_preference)
    assert_equal("floodgate-900-0", login.gamename)
  end
end

