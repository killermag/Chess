require_relative '../lib/game'
describe Chess do
  describe '#input' do 

    it 'handles wrong inputs' do 
      game = Chess.new
      game.piece = 'oihfa'
      expect(game.input).to receive(game.input)
    end

    it 're-prompts if the input type is wrong. ie, On whites turn selecting a
    black piece' do 

      end
    end 
  end
