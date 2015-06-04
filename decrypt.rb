require 'pry'

class Key
	def get_key
		key_input = gets.chomp
	end
end
#takes in a message
#encryptys message
#outputs encrypted message
class Enigma
	attr_reader :message, :date_offset, :key

	def initialize
	 	@message = message
	 	@date_offset = date_offset
	 	@key = keygen
	end

	def message
		incoming = File.open(ARGV[0], "r")
 		message = incoming.read
 		incoming.close
 		return message
	end
 # message_txt = ARGV[0]
 # output_message = ARGV[1]
	
	def date_offset
		time = Time.new.strftime("%d%m%y").to_i
		time_mult = time**2
		time_mult = time_mult.to_s
		time_offset = [time_mult[-1], time_mult[-2], time_mult[-3], time_mult[-4]].join
		return time_offset
	end

	def a_key
		a = key[0..1].to_i + date_offset[0].to_i
	end

	def b_key
		b = key[1..2].to_i + date_offset[1].to_i
	end

	def c_key
		c = key[2..3].to_i + date_offset[2].to_i
	end

	def d_key
		d = key[3..4].to_i + date_offset[3].to_i
	end



	def encrypt
		char_map = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "1", "2", "3", "4", "5", "6", "7", "8", "9",  " ", ",", "."]

		a_rotated = char_map.rotate(-a_key)
		a_hash = Hash[char_map.zip(a_rotated)]

		b_rotated = char_map.rotate(-b_key)
		b_hash = Hash[char_map.zip(b_rotated)]

		c_rotated = char_map.rotate(-c_key)
		c_hash = Hash[char_map.zip(c_rotated)]

		d_rotated = char_map.rotate(-d_key)
		d_hash = Hash[char_map.zip(d_rotated)]



		message_split_into_4 = message.scan(/..../)
			encrypted_message =	message_split_into_4.map do |letters|
			count = 0
	
			letters.chars.map do |letter|
				if count == 0
					newletter = a_hash[letter]
				elsif count == 1
					newletter = b_hash[letter]
				elsif count == 2
					newletter = c_hash[letter]
				else 
					newletter = d_hash[letter]
				end
				count += 1
				newletter
			end
					 	 
		end
		encrypted_message = encrypted_message.join
		message_write = File.open(ARGV[1], "w")
		message_write.write(encrypted_message)
		message_write.close

	end


	def keygen
	 	key = "09821"
	end

end

enigma = Enigma.new
encrypted_message = enigma.encrypt
puts "Created 'decrypted.txt' with the key #{enigma.key} and date #{Time.new.strftime("%d%m%y")}"