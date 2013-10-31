require 'lcd_pi/lcd_pi'

module LcdPi
	
	class Screen
		attr_accessor :time_ms, :port_rs, :port_en, :port_d4, :port_d5, :port_d6, :port_d7, :lines, :char_size
		require 'wiringpi'
		##Find Alpha Code Based On Position In Table [Upper_Bits, Lower_Bits] Starts From 0. Uppercase charraters only referenced. push upper bits by 2 for lowercase
		char =  ["A", [4, 1],
				 "B", [4, 2],
				 "C", [4, 3],
				 "D", [4, 4],
				 "E", [4, 5],
				 "F", [4, 6],
				 "G", [4, 7],
				 "H", [4, 8],
				 "I", [4, 9],
				 "J", [4, 10],
				 "K", [4, 11],
				 "L", [4, 12],
				 "M", [4, 13],
				 "N", [4, 14],
				 "O", [4, 15],
				 "P", [5, 0],
				 "Q", [5, 1],
				 "R", [5, 2],
				 "S", [5, 3],
				 "T", [5, 4],
				 "U", [5, 5],
				 "V", [5, 6],
				 "W", [5, 7],
				 "X", [5, 8],
				 "Y", [5, 9],
				 "Z", [5, 10],
				 "0", [3, 0],
				 "1", [3, 1],
				 "2", [3, 2],
				 "3", [3, 3],
				 "4", [3, 4],
				 "5", [3, 5],
				 "6", [3, 6],
				 "7", [3, 7],
				 "8", [3, 8],
				 "9", [3, 9],
				 "!" [2, 1],
	 		     """ [2, 2],
	 		     "#" [2, 3],
	 		     "$" [2, 4],
	 		     "%" [2, 5],
	 		     "&" [2, 6],
	 		     "'" [2, 7],
	 		     "(" [2, 8],
	 		     ")" [2, 9],
	 		     "*" [2, 10],
	 		     "+" [2, 11],
	 		     "," [2, 12],
	 		     "-" [2, 13],
	 		     "." [2, 14],
	 		     "/" [2, 15],
	 		     ":" [3, 10],
	 		     ";" [3, 11],
	 		     "<" [3, 12],
	 		     "=" [3, 13],
	 		     ">" [3, 14],
	 		     "?" [3, 15],
	 		     "@" [4, 0],
	 		     "[" [5, 11],
	 		     "]" [5, 13],
	 		     "^" [5, 14],
	 		     "_" [5, 15],
	 		     "`" [6, 0],
	 		     "{" [7, 11],
	 		     "|" [7, 12],
	 		     "}" [7, 13],
	 		     "->" [7, 14],
	 		     "<-" [7, 15],
	 		     "c1" [0, 0],
	 		     "c2" [0, 1],
	 		     "c3" [0, 2],
	 		     "c4" [0, 3],
	 		     "c5" [0, 4],
	 		     "c6" [0, 5],
	 		     "c7" [0, 6],
	 		     "c8" [0, 7]]
				   
		def initialize(T_MS, RS, EN, D4, D5, D6, D7, lines, char)
	      Wiringpi.wiringPiSetup
	      if T_MS.nil?
	      	@time_ms = 1.0000000/1000000
	      else
	      	@time_ms = T_MS
	      end
	      
		  @port_rs     = RS
		  @port_en     = EN
		  @port_d4     = D4
		  @port_d5     = D5
		  @port_d6     = D6
		  @port_d7     = D7
		  if lines
		  	@lines     = lines
		  else
		  	@lines     = 1
		  end
		  if not char == "*" && char
		  	@char_size = char
		  else
		  	@char_size = nil
		  end
	      # Set all pins to output mode (not sure if this is needed)
	      self.send_pins(1, 1, 1, 1, 1, 1)
	
	      self.class.initDisplay()
	      sleep @time_ms * 10
	      self.class.lcdDisplay(1, 1, 0)
	      self.class.setEntryMode()
		end
		
		def self.is_a_number?(s)
		  s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
		end
		
		def self.clear_screen
			
			self.send_pins(0, 0, 0, 0, 0, 0)
			
		end
		
		def self.pulseEnable()
		    # Indicate to LCD that command should be 'executed'
		    self.send_pins(, 0,,,,)
		    sleep @time_ms * 10
		    self.send_pins(, 1,,,,)
		    sleep @time_ms * 10
		    self.send_pins(, 0,,,,)
		    sleep @time_ms * 10
		end
		
		def self.lcdDisplay(display, cursor, block)
		    self.send_pins(0, 0, 0, 0, 0, 0)
		    
		    pulseEnable()
		    
			self.send_pins(0,, block, cursor, display, 1)
			
			pulseEnable()
		end
		
		def self.setEntryMode()
		    # Entry mode set: move cursor to right after each DD/CGRAM write
		    self.send_pins(0,, 0, 0, 0, 0)
		    pulseEnable()
			self.send_pins(0,, 0, 1, 1, 0)
		    pulseEnable()
		    sleep @time_ms
		  end
		
	    def self.initDisplay()
	    	
	    	 # Set function to 4 bit operation
		    i = 0
		    while i < 3     # Needs to be executed 3 times
		      # Wait > 40 MS
		      sleep 42 * @time_ms
		      self.send_pins(0, 0, 0, 0, 1, 1)
		      pulseEnable()
		      i += 1
		    end
		
		    # Function set to 4 bit
		    i = 0
		    while i < 2  # Needs to be executed 2 times
		      self.send_pins(0, 0, 0, 0, 1, 0)
		      pulseEnable()
		      i += 1
	    	end
	    	
		    self.send_pins(0,, 0, 0, @char_size, @lines)
	    	# Set number of display lines
    	    pulseEnable()
    	
    	    sleep @time_ms
    		self.send_pins(0, , 0, 0, 0, 0)
    	    # Display Off (2 blocks)
    	    pulseEnable()
    	
    	    sleep @time_ms
    		self.send_pins(0, , 0, 0, 0, 1)
    	    pulseEnable()
    	
    	    sleep @time_ms
    		self.send_pins(0, , 0, 0, 0, 0)
    	    # Display clear (2 blocks)
    	    pulseEnable()
    	
    	    sleep @time_ms
    		self.send_pins(0, , 1, 0, 0, 0)
    	    pulseEnable()
    	
    	    sleep @time_ms
    	    
    		self.send_pins(0, , 0, 0, 0, 0)
    	    # Entry mode set"
    	    pulseEnable()
    	
    	    sleep @time_ms
    	    
    		self.send_pins(0, , 1, 1, 1, 0)
    	    pulseEnable()
	    end
	    
		def self.decode_char(char)
			
			
			if char.match(/^[[:alpha:]]$/) == true
				value = char[char.rindex(char.upcase) + 1]
				if char.upcase == char
					value = value
				else
					value = [(value[0] + 2), value[1]]
				end
			else
				value = char[char.rindex(char) + 1]
			end
			
			return value
			
		end
		
		def self.send_text(text)
			decoded_array = []
			split_text = text.split(//)
			
			split_text.each do |char|
				code = self.decode_char(char)
				
				decoded_array << code
				
			end
			decoded_array.each do |code|
				
				if code[0] == 0
					upper = [0, 0, 0, 0]
				elsif code[0] == 1
					upper = [0, 0, 0, 1]
				elsif code[0] == 2
					upper = [0, 0, 1, 0]
				elsif code[0] == 3
					upper = [0, 0, 1, 1]
				elsif code[0] == 4
					upper = [0, 1, 0, 0]
				elsif code[0] == 5
					upper = [0, 1, 0, 1]
				elsif code[0] == 6
					upper = [0, 1, 1, 0]
				elsif code[0] == 7
					upper = [0, 1, 1, 1]
				elsif code[0] == 8
					upper = [1, 0, 0, 0]
				elsif code[0] == 9
					upper = [1, 0, 0, 1]
				elsif code[0] == 10
					upper = [1, 0, 1, 0]
				elsif code[0] == 11
					upper = [1, 0, 1, 1]
				elsif code[0] == 12
					upper = [1, 1, 0, 0]
				elsif code[0] == 13
					upper = [1, 1, 0, 1]
				elsif code[0] == 14
					upper = [1, 1, 1, 0]
				elsif code[0] == 15
					upper = [1, 1, 1, 1]
				end
				
				if code[1] == 0
					lower = [0, 0, 0, 0]
				elsif code[1] == 1
					lower = [0, 0, 0, 1]
				elsif code[1] == 2
					lower = [0, 0, 1, 0]
				elsif code[1] == 3
					lower = [0, 0, 1, 1]
				elsif code[1] == 4
					lower = [0, 1, 0, 0]
				elsif code[1] == 5
					lower = [0, 1, 0, 1]
				elsif code[1] == 6
					lower = [0, 1, 1, 0]
				elsif code[1] == 7
					lower = [0, 1, 1, 1]
				elsif code[1] == 8
					lower = [1, 0, 0, 0]
				elsif code[1] == 9
					lower = [1, 0, 0, 1]
				elsif code[1] == 10
					lower = [1, 0, 1, 0]
				elsif code[1] == 11
					lower = [1, 0, 1, 1]
				elsif code[1] == 12
					lower = [1, 1, 0, 0]
				elsif code[1] == 13
					lower = [1, 1, 0, 1]
				elsif code[1] == 14
					lower = [1, 1, 1, 0]
				elsif code[1] == 15
					lower = [1, 1, 1, 1]
				end
				
				self.send_pins(1, , upper[0], upper[1], upper[2], upper[3])
				pulseEnable()
				self.send_pins(1, , lower[0], lower[1], lower[2], upper[3])
				pulseEnable()
			end
		end
		def self.home
			self.send_pins(0, 0, 0, 0, 0, 0)
			pulseEnable()
			self.send_pins(0, 0, 0, 1, 0, 0)
		end
		def self.send_pins(RS, EN, D4, D5, D6, D7)
			if RS
				Wiringpi.digitalWrite(@port_rs, RS)
			end
			if EN
				Wiringpi.digitalWrite(@port_en, EN)
			end
			if D4
				Wiringpi.digitalWrite(@port_d4, D4)
			end
			if D5
				Wiringpi.digitalWrite(@port_d5, D5)
			end
			if D6
				Wiringpi.digitalWrite(@port_d6, D6)
			end
			if D7
				Wiringpi.digitalWrite(@port_d7, D7)
			end
		end
		
	end
	
end