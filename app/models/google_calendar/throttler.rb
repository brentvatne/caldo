module Caldo
  module GoogleCalendar
    class Throttler
      def initialize(client, requests_per_second)
        @sleep_duration    = 1.0 / requests_per_second
        @client            = client

        update_last_request_time
      end

      def method_missing(sym, *args, &block)
        command = lambda { client.send(sym, *args, &block) }
        queue << command
        execute_when_ready(command)
      end

      def execute_when_ready(command)
        if time_since_last_request >= sleep_duration && queue.first == command
          update_last_request_time
          queue.shift.call
        else
          sleep(sleep_duration)
          execute_when_ready(command)
        end
      end

      private
      attr_reader :client, :sleep_duration, :last_request_time

      def time_since_last_request
        Time.now - last_request_time
      end

      def update_last_request_time
        @last_request_time = Time.now
      end

      def queue
        @queue ||= []
      end
    end
  end
end
