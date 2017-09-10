class Psykube::CLI::Commands::LabeledIO
  include IO
  Colors = %i(
    light_red
    light_green
    light_yellow
    light_blue
    light_magenta
    light_cyan
    red
    green
    yellow
    blue
    magenta
    cyan
  ).shuffle
  @color : Symbol

  delegate read, to: @io

  def initialize(@io : IO, @label : String?, color : Symbol? = nil)
    @color = color || Colors.sample
  end

  def initialize(@io : IO, @label : String?, index : Int)
    @color = Colors[index % Colors.size]
  end

  def write(slice : Bytes)
    String.new(slice).strip.split("\n").each do |string|
      @io.puts ["[#{@label}]".colorize(@color), string].join(" ")
    end
  end
end
