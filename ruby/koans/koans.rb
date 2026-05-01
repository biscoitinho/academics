module Koans
  class KoanError < StandardError; end

  class TestCase
    def self.inherited(subclass)
      Runner.register(subclass)
    end

    def __
      :fill_me_in
    end

    def assert_equal(expected, actual)
      if expected == :fill_me_in || actual == :fill_me_in
        raise KoanError, "Replace __ with the correct value\n  Got: #{actual.inspect}"
      end
      unless expected == actual
        raise KoanError, "Expected: #{expected.inspect}\n  Got:      #{actual.inspect}"
      end
    end

    def assert(condition, msg = nil)
      if condition == :fill_me_in
        raise KoanError, "Replace __ with the correct value"
      end
      unless condition
        raise KoanError, msg || "Expected truthy but got: #{condition.inspect}"
      end
    end

    def assert_nil(value)
      unless value.nil?
        raise KoanError, "Expected nil but got: #{value.inspect}"
      end
    end

    def assert_raise(exception_class)
      yield
      raise KoanError, "Expected #{exception_class} to be raised but nothing was raised"
    rescue exception_class
      # ok
    end
  end

  class Runner
    @test_classes = []

    def self.register(klass)
      @test_classes << klass
    end

    def self.run
      total = 0
      passed = 0

      @test_classes.each do |klass|
        instance = klass.new
        methods = instance.public_methods(false)
                         .select { |m| m.to_s.start_with?("test_") }
                         .sort
        methods.each { total += 1 }
      end

      @test_classes.each do |klass|
        instance = klass.new
        methods = instance.public_methods(false)
                         .select { |m| m.to_s.start_with?("test_") }
                         .sort

        methods.each do |method|
          begin
            instance.send(method)
            passed += 1
          rescue KoanError => e
            puts "\n(o_o)  You need enlightenment...\n"
            puts "       #{method} (#{klass})"
            puts "       #{e.message}"
            source = find_source(klass, method)
            puts "       File: #{source}" if source
            puts "\n       Progress: #{passed}/#{total} completed\n\n"
            return
          rescue => e
            puts "\n(x_x)  Unexpected error in #{method} (#{klass}):"
            puts "       #{e.class}: #{e.message}"
            puts "\n       Progress: #{passed}/#{total} completed\n\n"
            return
          end
        end
      end

      puts "\n(^_^)  Congratulations! All #{total} koans completed!"
      puts "       You are on the path to Ruby enlightenment.\n\n"
    end

    def self.find_source(klass, method)
      location = klass.instance_method(method).source_location
      return nil unless location
      file, line = location
      "#{File.basename(file)}:#{line}"
    end
  end
end
