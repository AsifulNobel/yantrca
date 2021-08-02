# frozen_string_literal: true

module Yantrca
  # State to update a note
  class UpdateNoteState
    def initialize(user_interface, note_name)
      @user_interface = user_interface
      @note_name = note_name
    end

    def activate
      @user_interface.clear
      @user_interface.top_bar_title = @note_name
      show_available_actions
      @user_interface.show_cursor
      load_note
      process_user_input
    end

    private

    def load_note
      @buffer = Note.note(@note_name)
      @user_interface.show_content(@buffer)
    end

    def process_user_input
      loop do
        input = @user_interface.content_input

        return unless input

        case input
        when 24
          return StartState.new(@user_interface)
        when 19
          save_note
          return StartState.new(@user_interface)
        else
          @buffer = "#{@buffer}#{input}"
          @user_interface.show_content(input.to_s)
          next
        end
      end
    end

    def show_available_actions
      actions = [
        ['^C', 'Exit'],
        ['^S', 'Save'],
        ['^X', 'Discard']
      ]
      @user_interface.show_actions_on_bottom_bar(actions)
    end

    def save_note
      return if Note.update_note(@note_name, @buffer)

      @user_interface.clear_bottom_bar
      @user_interface.show_on_bottom_bar('Failed to save note!')
      @user_interface.bottom_bar_input
    end
  end
end
