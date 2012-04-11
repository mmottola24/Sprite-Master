require 'rubygems'
require 'json'

# I used an online tool to convert xml/plist file to JSON format
# http://json.online-toolz.com/tools/xml-json-convertor.php

prefix = "glyphicon"

# load file
json = File.read('sheetmap.json')

# parse JSON into contents
contents = JSON.parse(json)

# get of items
keys = contents["plist"]["dict"]["dict"][0]["key"]
items = contents["plist"]["dict"]["dict"][0]["dict"]


@cssFile = ''
@htmlRefs = ''

masterKeys = []

# start css file
@cssFile << '[class^="glyphicon-"] {
  background-image: url("sprites/glyphicons-sprite-sheet.png");
  background-position: 14px 14px;
  background-repeat: no-repeat;
  display: inline-block;
  width: 25px;
  height: 24px;
  vertical-align: text-top;
  }'


# loop through each key
keys.each_with_index do |key, index|

  # take the key and remove prefixes to file name
  name = key.gsub(/^\w*_[0-9]*_/i, "").gsub(/.png$/, "").gsub('_', '-').gsub('@2x', '-x2')

  # push into master keys file for parsing down above
  masterKeys.push name

end

# loop through items to retrieve coordinates and dimensions
items.each_with_index do |item, index|
  data = item["string"].last
  data = data.scan(/(?:[0-9]+,.[0-9]+)/)

  # get coords and dimensions from data
  coords = data[0].gsub(" ", "").split(",")
  dimensions = data[1].gsub(" ", "").split(",")

  # build css rules
  # .[prefix]-[name] { background-position: -14px -14px; width: 24px; height: 24px; }
  key = masterKeys[index]

  @cssFile << "\n.#{prefix}-#{key} {"
  @cssFile << " background-position: -#{coords[0]}px -#{coords[1]}px; width: #{dimensions[0]}px; height: #{dimensions[1]}px; "
  @cssFile << "} "

end

# write css file
filename = prefix + '-sprites.css'
write = File.open(filename, 'w') { |f| f.write(@cssFile) }

if write > 0
  puts "wrote to " + filename
end

puts "building html docs..."

# building html docs
@htmlRefs << '<!doctype><html><head><title>Glyphicon Sprite Sheets</title><link href="' + filename + '" rel="stylesheet" /><link href="' + prefix + '-colors.css" rel="stylesheet" />'
@htmlRefs << '<style>
  ul { margin-top: 75px; }
  li {
    float: left;
    margin-right: 15px;
    list-style-type: none;
    height: 100px;
    width: 20%;
  }
  </style>'
@htmlRefs << '</head><body>'

@htmlRefs << '<h2>Glyphicon Sprite Sheet</h2><p>Add below classes to &#60;i&#62; tag. <br> Change colour by adding class names of glyphicon-blue, glyphicon-red, glyphicon-green or glyphicon-white. Give it a try in browser.</p>'

@htmlRefs << '<ul>'
masterKeys.each do |key|
  @htmlRefs << "<li><i class='#{prefix}-#{key}'></i> #{prefix}-#{key}</li>"
end
@htmlRefs << '</ul>'

@htmlRefs << '</body></html>'

# write html docs file
filename = prefix + '-sprites-refs.html'
write = File.open(filename, 'w') { |f| f.write(@htmlRefs) }

if write > 0
  puts "wrote to " + filename
end
