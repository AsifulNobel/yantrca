# frozen_string_literal: true

require_relative 'ui'

if __FILE__ == $PROGRAM_NAME
  terminalUi = UI::Terminal.new

  begin
    terminalUi.wait_for_note_selection_user_input
  rescue => exception
    File.open('errors.txt', 'w') do |f|
      f << exception.message
      f << exception.backtrace
      f << "\n"
    end
  ensure
    terminalUi.close
  end
end
