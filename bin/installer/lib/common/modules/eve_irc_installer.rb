module Core

  def report_error(params = {})
    err_msg = params[:msg] || 'No message provided'
    err_fatal = params[:is_fatal] || false

    if $prompt.nil?
      p err_msg
      p err_fatal
    else
      
    end
  end

end