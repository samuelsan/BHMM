def search(search_text)
	# search function, returns an array of location objects found.
	time = Time.now	
	result = []
	Location.all.each { |location| result << location if location.address.downcase.include? search_text.downcase }
  puts "Search took #{(Time.now - time)*100}ms to complete"
	result
end

