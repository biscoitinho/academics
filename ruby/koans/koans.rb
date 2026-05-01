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
        raise KoanError, "Zastap __ poprawna wartoscia\n  Wynik: #{actual.inspect}"
      end
      unless expected == actual
        raise KoanError, "Oczekiwano: #{expected.inspect}\n  Otrzymano: #{actual.inspect}"
      end
    end

    def assert(condition, msg = nil)
      if condition == :fill_me_in
        raise KoanError, "Zastap __ poprawna wartoscia"
      end
      unless condition
        raise KoanError, msg || "Oczekiwano wartosci prawdziwej, ale otrzymano: #{condition.inspect}"
      end
    end

    def assert_nil(value)
      unless value.nil?
        raise KoanError, "Oczekiwano nil, ale otrzymano: #{value.inspect}"
      end
    end

    def assert_raise(exception_class)
      yield
      raise KoanError, "Oczekiwano wyjatku #{exception_class}, ale nie zostal rzucony"
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
            puts "\n(o_o)  Potrzebujesz oswiecenia...\n"
            puts "       #{method} (#{klass})"
            puts "       #{e.message}"
            source = find_source(klass, method)
            puts "       Plik: #{source}" if source
            puts "\n       Postep: #{passed}/#{total} ukonczone\n\n"
            return
          rescue => e
            puts "\n(x_x)  Nieoczekiwany blad w #{method} (#{klass}):"
            puts "       #{e.class}: #{e.message}"
            puts "\n       Postep: #{passed}/#{total} ukonczone\n\n"
            return
          end
        end
      end

      puts "\n(^_^)  Gratulacje! Wszystkie #{total} koanow ukonczone!\n"
      puts "       Jestes na sciezce do oswiecenia Ruby.\n\n"
    end

    def self.find_source(klass, method)
      location = klass.instance_method(method).source_location
      return nil unless location
      file, line = location
      "#{File.basename(file)}:#{line}"
    end
  end
end
