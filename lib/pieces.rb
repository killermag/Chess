class Piece
  attr_accessor :p, :structure, :type, :pos, :name   
  def initialize(pos,structure = nil ,type = nil , name = nil, p = nil )
    @pos = pos 
    @structure = structure
    @type = type
    @p = p
    @name = name 
  end
end
