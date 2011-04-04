module RailService
  class Endpoint

    def self.generate(&block)
      Class.new(RailService::Endpoint).tap do |klass|
        klass.block = block
      end
    end

    class << self
      attr_accessor :block
    end

    attr_internal :env, :headers, :request

    def self.call(env)
      new.call(env)
    end

    def params
      @_params ||= request.parameters
    end

    def status
      @_status
    end

    def status=(status)
      @_status = Rack::Utils.status_code(status)
    end

    def call(env)
      @_env = env
      @_headers = { "Content-Type" => "text/javascript" }
      @_status = 200
      @_request = ActionDispatch::Request.new(@_env)

      body = instance_eval(&self.class.block).to_json
      [@_status, @_headers, [body]]
    end

  end
end
