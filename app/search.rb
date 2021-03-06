def search(search_text)
	# search function, returns an array of location objects found.
	time = Time.now	
	result = []
	return if search_text == '' or search_text.nil?
	Location.all.each { |location| result << location if location.address.downcase.include? search_text.downcase or User.find(location.landlord_id).name.downcase.include? search_text.downcase }
  puts "Search took #{(Time.now - time)*100}ms to complete"
	result
end

