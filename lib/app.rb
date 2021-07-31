# frozen_string_literal: true

require_relative 'ui'
require_relative 'states/start_state'

module Yantrca
  class App
    def initialize
      @user_interface = UI.new
    end

    def start
      @start = StartState.new(@user_interface)
      @start.activate
    end

    def stop
      @user_interface.close
    end
  end
end
