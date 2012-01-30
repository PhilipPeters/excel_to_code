require_relative '../../util/not_supported_exception'

class MapValuesToRuby

  def map(ast)
    if ast.is_a?(Array)
      operator = ast[0]
      if respond_to?(operator)
        send(operator,*ast[1..-1])
      else
        raise NotSupportedException.new("#{operator} in #{ast.inspect} not supported")
      end
    else
      raise NotSupportedException.new("#{ast} not supported")
    end
  end
  
  def blank
    "nil"
  end
    
  def number(text)
    case text
    when /\./
      text.to_f.to_s
    when /e/i
      text.to_f.to_s
    else
      text.to_i.to_s
    end
  end
  
  def string(text)
    text.inspect
  end
  
  ERRORS = {
    "#NAME?" => ":name",
    "#VALUE!" => ":value",
    "#DIV/0!" => ":div0",
    "#REF!" => ":ref",
    "#N/A" => ":na"
  }
  
  REVERSE_ERRORS = ERRORS.invert
  
  def error(text)
    ERRORS[text] || (raise NotSupportedException.new("#{text.inspect} error not recognised"))
  end
  
  def boolean_true
    "true"
  end
  
  def boolean_false
    "false"
  end
  
end
