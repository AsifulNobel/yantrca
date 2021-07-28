# frozen_string_literal: true

require_relative 'ui'

if __FILE__ == $PROGRAM_NAME
  terminal_ui = UI::Terminal.new

  begin
    terminal_ui.populate_notes_menu([
                                      'hipster ipsum',
                                      'lorem ipsum',
                                      'imperdiet nulla malesuada pellentesque elit eget gravida cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus mauris'
                                    ])

    loop do
      terminal_ui.wait_for_note_selection_user_input
    end
  rescue StandardError => e
    File.open('logs/errors.txt', 'w') do |f|
      f << e.message
      f << e.backtrace
      f << "\n"
    end
  ensure
    terminal_ui.close
  end
end
