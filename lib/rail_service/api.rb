module RailService
  class API

    def self.reset!
      @settings = [{}]
    end

    def self.settings
      Hash.new.tap do |merged_settings|
        @settings.each do |setting_frame|
          merged_settings.merge!(setting_frame)
        end
      end
    end

    def self.set(key, value)
      @settings.last[key.to_sym] = value
    end

    def self.prefix(prefix = nil)
      prefix ? set(:root_prefix, prefix) : settings[:root_prefix]
    end

    def self.get(path, &block)
      app = generate_endpoint(&block)
      path = compile_path(path)

      Rails.application.routes.draw do
        get path => app
      end
    end

    def self.version(*new_versions, &block)
      new_versions.any? ? nest(block){ set(:version, new_versions) } : settings[:version]
    end

    def self.namespace(space = nil, &block)
      if space || block_given?
        nest(block) do
          set(:namespace, space.to_s) if space
        end
      else
        Rack::Mount::Utils.normalize_path(@settings.map{|s| s[:namespace]}.join('/'))
      end
    end

    def self.nest(*blocks, &block)
      blocks.reject!{|b| b.nil?}
      if blocks.any?
        @settings << {}
        instance_eval &block if block_given?
        blocks.each{|b| instance_eval &b}
        @settings.pop
      else
        instance_eval &block
      end
    end

    def self.helpers(&block)
      if block_given?
        m = @settings.last[:helpers] || Module.new
        m.class_eval &block
        set(:helpers, m)
      else
        merged_helpers
      end
    end

    def self.merged_helpers
      m = Module.new
      @settings.each do |s|
        m.send :include, s[:helpers] if s[:helpers]
      end
      m
    end

    def self.compile_path(path)
      parts = []
      parts << prefix if prefix
      parts << ':version' if version
      parts << namespace if namespace
      parts << path
      Rack::Mount::Utils.normalize_path(parts.join('/'))
    end

    def self.generate_endpoint(&block)
      Endpoint.generate(&block).tap do |endpoint|
        endpoint.send(:include, helpers)
      end
    end

    def self.inherited(subclass)
      subclass.reset!
    end

    reset!
  end
end
