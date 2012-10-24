class Todo
  def initialize time, callback, *args
    @args = args
    @time = time
    @callback = callback
  end
  def tick
    @time -= 1
    if @time <= 0
      @callback.call(*@args)
      true
    end
  end
end
