# frozen_string_literal: true

require_relative 'ui'

if __FILE__ == $PROGRAM_NAME
  terminalUi = UI::Terminal.new

  begin
    terminalUi.populate_notes_menu([
      'hipster ipsum',
      'lorem ipsum',
      'imperdiet nulla malesuada pellentesque elit eget gravida cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus mauris'
    ])

    loop do
      terminalUi.wait_for_note_selection_user_input
    end
  rescue => exception
    File.open('logs/errors.txt', 'w') do |f|
      f << exception.message
      f << exception.backtrace
      f << "\n"
    end
  ensure
    terminalUi.close
  end
end
