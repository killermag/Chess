module Serializable 
  def save 
    puts "autosave was enabled" if @autosave
    puts "enter the filename"
    filename = "saved/#{gets.chomp}" 
    if File.exist?(filename)
      puts "File already exists"
      save
    else 
      open(filename,'w') do |file|
        Marshal.dump(self,file)
      end
      puts "file saved "
    end
  end

  def loading 
    puts "enter the name of the file you want to load"
    filename = "saved/#{gets.chomp}"
    if File.exist?(filename)
      game = Marshal.load(File.binread(filename))
      game.play_loop
      
    else
      puts "File doesnt exist. \n To try loading again enter 1 \n
      To quit the program enter 2 \n To exit to the menu enter q"
      answer = gets.chomp 
      if answer == '1'
        return loading
      elsif answer == '2'
        exit!
      elsif answer == 'q'
        return 'q'
      end
    end
  end
end
