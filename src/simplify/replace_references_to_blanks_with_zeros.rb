class ReplaceReferencesToBlanksWithZeros

  attr_accessor :references, :current_sheet_name, :inline_ast
  attr_accessor :count_replaced
  
  def initialize(references = nil, current_sheet_name = nil, inline_ast = nil)
    @references, @current_sheet_name, @inline_ast = references, [current_sheet_name], inline_ast
    @count_replaced = 0
    @inline_ast ||= lambda { |sheet, ref, references| true } # Default is to always inline
  end
  
  def map(ast)
    return ast unless ast.is_a?(Array)

    sheet = nil
    ref = nil

    case ast.first
    when :sheet_reference
      return ast unless ast[2][0] == :cell
      sheet = ast[1].to_sym
      ref = ast[2][1].to_s.upcase.gsub('$','').to_sym
    when :cell
      sheet = current_sheet_name.last
      ref = ast[1].to_s.upcase.gsub('$', '').to_sym
    else
      # We aren't interested
      return ast
    end

    ast_to_inline = references[[sheet, ref]] || [:blank]
    
    return ast unless ast_to_inline == [:blank]

    if inline_ast.call(sheet, ref, references)
      ast.replace([:number, 0])
    else
      reference = [:sheet_reference, sheet, [:cell, ref]]
      ast.replace([:function, :IF, [:function, :ISBLANK, reference], [:number, 0], reference])
    end
    ast
  end
end
