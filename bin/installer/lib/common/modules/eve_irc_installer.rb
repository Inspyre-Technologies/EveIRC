module EveIRCInstaller
  require_relative '../classes/log'
  require_relative '../classes/setup'
  require_relative '../classes/environment'

  $logger = Log.new

  @current_log_entry = $logger.entry

  def decide_prompt(msg)
    if $tty_present.nil?
      puts msg
    else
      puts msg + 'w/ prompt'
    end
  end

  def err_exit(expected = false)
    case expected

    when true
      exit
    when false
      raise NetworkError
    else
      raise InternalApplicationError
    end
  end

  def user_exit(params = {})
    expected    = params[:expected] || false
    parting_msg = params[:msg] || nil

  end

  def report_error(params = {})
    err_msg = params[:msg] || 'No message provided'
    err_lvl = params[:lvl] || '3'

    msg = err_msg + err_lvl

    if $prompt.nil?
      p err_msg
      p err_lvl
    else
      $prompt.warn msg
    end
  end

end