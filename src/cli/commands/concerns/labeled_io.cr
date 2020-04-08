class Psykube::CLI::Commands::LabeledIO < IO::FileDescriptor
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

  def initialize(@io : IO::FileDescriptor, @label : String?, color : Symbol? = nil)
    @volatile_fd = @io.@volatile_fd
    @closed = @io.@closed
    @color = color || Colors.sample
  end

  def initialize(@io : IO::FileDescriptor, @label : String?, index : Int)
    @volatile_fd = @io.@volatile_fd
    @closed = @io.@closed
    @color = Colors[index % Colors.size]
  end

  def write(slice : Bytes)
    String.new(slice).strip.split("\n").each do |string|
      @io.puts ["[#{@label}]".colorize(@color), string].join(" ")
    end
  end
end
