# frozen_string_literal: true

module Yantrca
  class StartState
    def initialize(user_interface)
      @user_interface = user_interface
    end

    def activate
      @user_interface.clear
      @user_interface.top_bar_title = 'Yet Another Note Taking Console App 📓️'
      @user_interface.user_input
    end
  end
end
