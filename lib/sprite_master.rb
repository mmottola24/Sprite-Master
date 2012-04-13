require 'rubygems'
require 'json'
require 'xmlsimple'
require 'pp'

class SpriteMaster
  def initialize(options = {})
    @prefix = options[:prefix]
    @img    = get_filename options[:img], 'png'
    @master_keys = []
    @dst    = ""
    @src    = get_filename options[:src], 'plist'
    @format = (get_extension @src)[0]

  end
  
  def generate_css
    contents     = get_src_contents(@src)
    if @format == 'json'
      keys         = contents['plist']['dict']['dict'][0]['key']
      items        = contents['plist']['dict']['dict'][0]['dict']
    else
      keys = contents['dict'][0]['dict'][0]['key']
      items = contents['dict'][0]['dict'][0]['dict']
    end
    css          = ''
    
    # Start css file.
    css << '[class^="' << @prefix << '-"] {
      background-image: url("' << @img << '");
      background-position: 0 0;
      background-repeat: no-repeat;
      display: inline-block;
      width: 0;
      height: 0;
      vertical-align: text-top;
    }'
    
    # Loop through each key.
    keys.each do |key|
      # Take the key and remove prefixes to the file name
      name = key.gsub(/^\w*_[0-9]*_/i, "").gsub(/.png$/, "").gsub('_', '-').gsub('@2x', '-x2')
      # Push into master keys file for parsing down above
      @master_keys.push name
    end
    
    # Loop through items to retrieve coordinates and dimensions.
    items.each_with_index do |item, index|
      data = item["string"].last.scan(/(?:[0-9]+,.[0-9]+)/)
      
      # Get coordinates and dimensions from data
      coords = data[0].gsub(" ", "").split(",")
      dimensions = data[1].gsub(" ", "").split(",")
      key = @master_keys[index]
      
      # Build css rules
      # .[prefix]-[name] { background-position: -14px -14px; width: 24px; height: 24px; }
      css << "\n." << @prefix << "-" << key << "{"
      css << " background-position: -" << coords[0] << "px -" << coords[1] << "px; "
      css << "width: " << dimensions[0] << "px; "
      css << "height: " << dimensions[1] << "px; "
      css << "}"
    end
    
    # Write css file
    @dst = @prefix + '-sprites.css'
    file = File.open(@dst, 'w') { |f| f.write(css) }
    
    if file > 0
      @dst
    else
      nil
    end
  end
  
  def generate_docs
    formatted_prefix = @prefix.capitalize
    html = '<!doctype><html><head><title>' + formatted_prefix + ' Sprite Sheets</title><link href="' + @dst + '" rel="stylesheet">'
    html << '<style>
      ul { margin-top: 75px; }
      li {
        float: left;
        margin-right: 15px;
        list-style-type: none;
        height: 100px;
        width: 20%;
      }
      </style>'
    html << '</head><body>'
    
    html << '<h2>'+formatted_prefix+' Sprite Sheet</h2><p>Add the classes below to the &#60;i&#62; tag.</p>'
    
    html << '<ul>'
    @master_keys.each do |key|
      html << "<li><i class='#{@prefix}-#{key}'></i> #{@prefix}-#{key}</li>"
    end
    html << '</ul>'
    
    html << '</body></html>'
    
    # write html docs file
    filename = @prefix + '-sprites.html'
    file = File.open(filename, 'w') { |f| f.write(html) }  
    
    if file > 0
      filename
    else
      nil
    end
  end
  
  protected
  
  def get_src_contents(src)
    if @format == 'xml' or @format == 'plist'
      XmlSimple.xml_in(src)
    else
      JSON.parse(File.read(src))
    end
  end

  # checks if a given filename has an extension, if it does not then it appends default extension to filename
  def get_filename filename, extension = 'png'
    file_extension = get_extension filename
    filename = (file_extension.empty?) ? filename + '.' + extension : filename
  end

  # returns the extension of a given filename
  def get_extension filename
    filename.to_s.scan(/\.([\w+-]+)$/).flatten
  end
end