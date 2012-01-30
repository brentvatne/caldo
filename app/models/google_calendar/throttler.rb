module Caldo
  module GoogleCalendar
    class Throttler
      def initialize(client, requests_per_second)
        @sleep_duration = 1.0 / requests_per_second
        @client = client
      end

      def queue
        @queue ||= []
      end

      def method_missing(sym, *args, &block)
        command = lambda { @client.send(sym, *args, &block) }
        queue << command
        execute_when_ready(command)
      end

      def execute_when_ready(command)
        if queue.size > 1
          sleep @sleep_duration
        end

        if queue.first == command
          result = command.call
          queue.shift
        else
          execute_when_ready(command)
        end

        result
      end
    end
  end
end
