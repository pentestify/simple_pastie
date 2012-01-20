require 'sinatra/base'

helpers do
  def sanitize(string)
    return "" unless string
    string.gsub!("</pre>","(.)(.)")
    # TODO - more filterin here pls!
    return string
  end
end
