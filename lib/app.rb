# frozen_string_literal: true

require_relative 'ui'
require_relative 'states/start_state'

module Yantrca
  class App
    def initialize
      @user_interface = UI.new
    end

    def start
      current_state = StartState.new(@user_interface)

      loop do
        break unless current_state

        current_state = current_state.activate
      end
    end

    def stop
      @user_interface.close
    end
  end
end
