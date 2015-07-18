require './config/environment'

def populate_json
#lat,long
coord = {vancouver:[49,123],
				edmonton:[53,113],
				calgray:[51,114],
				winnpeg:[49,97],
				toronto:[43,79],
				montreal:[45,73],
				halifax:[44,64]
}
histo = Hash.new(0)

Location.all.pluck(:city).each do |city|
histo[city.downcase.to_sym] += 1
end

coord_histo = ""

coord.each_pair do |key,value|
a = value[0].to_s + ', ' + value[1].to_s + ', ' + histo[key.to_sym].to_s
coord_histo = coord_histo + a
end
result = "[['user',[" + coord_histo +  "]]]"
result
end



def main
	f = File.open("./public/globe/user.json",'w')
	f.write(populate_json)
	f.close
end

main





