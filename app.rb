require 'gosu'

#classes
require './particles/particle_engine'
require './modes/menu_mode'
require './player'

class GameWindow < Gosu::Window
  WIDTH = (Gosu.screen_width * 0.9).round
  HEIGHT = (Gosu.screen_height * 0.8).round
  TIME_BETWEEN_GAMES = 1000
  attr_reader :shots
  attr_reader :font, :ship_images, :effects
  attr_reader :particles
  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Gosu Tutorial Game"
    @players = (Array.new(4) {|x| Player.new(x) })

    @between_games = true

    @font = Gosu::Font.new(self, "Verdana", 24)
    @ship_images = Gosu::Image.load_tiles(self, "ships.png", 26*2, 18*2, false)
    @effects = Gosu::Image.load_tiles(self, "assets.png", 24, 24, false)
    @particles = ParticleEngine.new(self)

    @mode = MenuMode.new(self, @players)
  end

  def update
    @particles.tick
    @mode = @mode.update || @mode
  end

  def draw
    @particles.draw
    @mode.draw
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
    @mode.button_down(id)
  end

  def sample(name)
    @samples ||= {}
    @samples[name] ||= Gosu::Sample.new(self, "sounds/#{name}.wav")
  end
end

window = GameWindow.new
window.show
