require_relative '../../lib/controller_base'

class StylesheetsController < ControllerBase
  def stylesheet
    filename = File.dirname(__FILE__) + '/../stylesheets/stylesheet.css'
    res.body = File.read(filename)
    res.content_type = 'text/css'
    @already_built_response = true
  end
end
