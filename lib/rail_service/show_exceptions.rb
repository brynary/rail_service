module RailService
  class ShowExceptions < ActionDispatch::ShowExceptions
    FAILSAFE_RESPONSE = [500, {'Content-Type' => 'text/javascript'}, [""]]

  private

    def render_exception(env, exception)
      log_error(exception)
      rescue_action_with_json(exception)
    rescue Exception => failsafe_error
      $stderr.puts "Error during failsafe response: #{failsafe_error}\n  #{failsafe_error.backtrace * "\n  "}"
      FAILSAFE_RESPONSE
    end

    def rescue_action_with_json(exception)
      status = status_code(exception)
      path = "#{public_path}/#{status}.json"

      if File.exist?(path)
        render_json(status, File.read(path))
      elsif status.to_s == "500"
        serialized_exception = {
          :exception => {
            :class => exception.class.name,
            :message => exception.message,
            :backtrace => exception.backtrace.join("\n")
          }
        }

        render_json(status, serialized_exception.to_json)
      else
        render_json(status, "")
      end
    end

    def render_json(status, body)
      [status, {'Content-Type' => 'text/javascript', 'Content-Length' => body.bytesize.to_s}, [body]]
    end

  end
end
