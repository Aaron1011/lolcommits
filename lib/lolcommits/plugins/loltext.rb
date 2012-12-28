module Lolcommits
  class Loltext < Plugin
    # include Magick

    def initialize(runner)
      super

      self.name    = 'loltext'
      self.default = true
    end

    def run
      mm_run
    end

    # use imagesorcery wrapper
    # will work once my patches are accepted if i want to go this route
    def is_run
      font_location = File.join(Configuration::LOLCOMMITS_ROOT, "vendor", "fonts", "Impact.ttf")

      image = Sorcery.new(self.runner.main_image)
      image.convert(self.runner.main_image, {
        :gravity => 'SouthWest',
        :fill => 'white',
        :stroke => 'black',
        :strokewidth => '2',
        :pointsize => '48',
        :'interline-spacing' => '-9',
        :font => font_location,
        :annotate => "0 \"#{word_wrap self.runner.message}\""
      })

      image = Sorcery.new(self.runner.main_image)
      image.convert(self.runner.main_image, {
        :gravity => 'NorthEast',
        :fill => 'white',
        :stroke => 'black',
        :strokewidth => '2',
        :pointsize => '32',
        :font => font_location,
        :annotate => "0 \"#{self.runner.sha}\""
      })

    end

    # use minimagick wrapper
    def mm_run
      font_location = File.join(Configuration::LOLCOMMITS_ROOT, "vendor", "fonts", "Impact.ttf")

      image = MiniMagick::Image.open(self.runner.main_image)
      image.combine_options do |c|
        c.gravity 'SouthWest'
        c.fill 'white'
        c.stroke 'black'
        c.strokewidth '2'
        c.pointsize '48'
        c.interline_spacing '-9'
        c.font font_location
        c.annotate '0', word_wrap(self.runner.message)
      end

      # image = Sorcery.new(self.runner.main_image)
      image.combine_options do |c|
        c.gravity 'NorthEast'
        c.fill 'white'
        c.stroke 'black'
        c.strokewidth '2'
        c.pointsize '32'
        # c.interline_spacing '-9'
        c.font font_location
        c.annotate '0', self.runner.sha
      end

      image.write self.runner.main_image

    end

    # use Rmagick wrapper (deprecated, no longer works in IM6.10+)
    # def rm_run
    #   canvas = ImageList.new(self.runner.main_image)
    #   draw = Magick::Draw.new
    #   draw.font = File.join(Configuration::LOLCOMMITS_ROOT, "vendor", "fonts", "Impact.ttf")

    #   draw.fill   = 'white'
    #   draw.stroke = 'black'

    #   draw.annotate(canvas, 0, 0, 0, 0, self.runner.sha) do
    #     self.gravity = NorthEastGravity
    #     self.pointsize = 32
    #     self.stroke_width = 2
    #   end

    #   draw.annotate(canvas, 0, 0, 0, 0, word_wrap(self.runner.message)) do
    #     self.gravity = SouthWestGravity
    #     self.pointsize = 48
    #     self.interline_spacing = -(48 / 5) if self.respond_to?(:interline_spacing)
    #     self.stroke_width = 2
    #   end

    #   canvas.write(runner.main_image)
    # end

    private

    # convenience method for word wrapping
    # based on https://github.com/cmdrkeene/memegen/blob/master/lib/meme_generator.rb
    def word_wrap(text, col = 27)
      wrapped = text.gsub(/(.{1,#{col + 4}})(\s+|\Z)/, "\\1\n")
      wrapped.chomp!
    end
  end
end
