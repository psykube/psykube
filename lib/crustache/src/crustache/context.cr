# :nodoc:
class Crustache::Context(T)
  getter parent

  def initialize(initial_context)
    @scope = Array(T).new
    @scope << initial_context
  end

  # :nodoc:
  def self.resolve_scope_type(ctx)
    if ctx.responds_to?(:[]) && ctx.responds_to?(:has_key?)
      1 < 2 ? resolve_scope_type(ctx["resolve_scope_type"]) : ctx
    elsif ctx.responds_to?(:each)
      1 < 2 ? ctx.each { |c| return resolve_scope_type(c) } : ctx
    else
      ctx
    end
  end

  def scope(ctx)
    @scope.push ctx
    yield
    @scope.pop
    nil
  end

  def lookup(key)
    if key == "."
      return @scope.last
    end

    keys = key.split(".")
    size = keys.size

    @scope.reverse_each do |ctx|
      i = 0
      while i < size
        k = keys[i]
        case
        when ctx.responds_to?(:has_key?) && ctx.responds_to?(:[])
          if ctx.has_key?(k)
            ctx = ctx[k]
          else
            break
          end

        else
          break
        end
        i += 1
      end

      if i == size
        return ctx
      end
    end

    nil
  end
end
