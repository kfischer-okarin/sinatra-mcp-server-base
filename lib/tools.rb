module Tools
  class << self
    def tools
      @tools ||= []
    end

    def define(...)
      ModelContextProtocol::Tool.define(...).tap do |tool|
        tools << tool
      end
    end

    def require_all_tool_files
      Dir.glob("tools/*.rb", base: __dir__).each do |file|
        require_relative file
      end
    end
  end
end
