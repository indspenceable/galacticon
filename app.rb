require 'gosu'

#classes
require './particles/particle_engine'
require './modes/menu_mode'
require './player'
require './todo'

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
    @delays = []

  end

  def update
    @particles.tick
    @delays.reject!(&:tick)
    @mode = @mode.update || @mode
  end

  def draw
    @particles.draw
    @mode.draw
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
      #wasn't sucessfully closing unless I freed all songs...
      @songs.each do |k,v|
        @songs[k] = nil
      end
    end
    @mode.button_down(id)
  end

  def delay ms, args, &blk
    @delays << Todo.new(ms, blk, args)
  end

  def sample(name)
    @samples ||= {}
    @samples[name] ||= Gosu::Sample.new(self, "sounds/#{name}.wav")
  end
  def songs(name)
    @songs ||= {}
    @songs[name] ||= Gosu::Song.new(self, "music/#{name}.mp3")
  end
end

window = GameWindow.new
window.show
