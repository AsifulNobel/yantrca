# frozen_string_literal: true

module Yantrca
  class StartState
    TITLE = 'Yet Another Note Taking Console App 📓️'

    def initialize(user_interface)
      @user_interface = user_interface
    end

    def activate
      @user_interface.clear
      @user_interface.top_bar_title = TITLE
      show_available_actions
      show_existing_notes
      process_user_input
    end

    private

    def process_user_input
      loop do
        input = @user_interface.user_input

        case input
        # when 1
        #   # return add note state
        when 3
          break
        else
          @user_interface.show_content(input.to_s)
          next
        end
      end
    end

    def show_available_actions
      actions = [
        ['^C', 'Exit'],
        ['^A', 'Add Note'],
        ['^U', 'Update Note'], # This should be available only if notes menu has alteast one note
        ['^D', 'Delete Note']
      ]
      @user_interface.show_actions_on_bottom_bar(actions)
    end

    def show_existing_notes
      @notes = existing_notes

      if !@notes.empty?
        @user_interface.show_menu(@notes)
      else
        @user_interface.show_content('No Notes Found!')
        @user_interface.hide_cursor
      end
    end

    def existing_notes
      begin
        File.open(File.join('notes', 'list.json')) do
        end
      rescue Errno::ENOENT
        []
      end
    end
  end
end
