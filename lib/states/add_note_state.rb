# frozen_string_literal: true

require_relative 'start_state'
require 'securerandom'

module Yantrca
  class AddNoteState
    def initialize(user_interface)
      @user_interface = user_interface
      @buffer = ''
    end

    def activate
      @user_interface.clear_content
      @user_interface.clear_bottom_bar
      show_available_actions
      @notes = Note.existing_notes
      process_user_input
    end

    private

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

    def save_note
      @user_interface.clear_bottom_bar
      @user_interface.show_on_bottom_bar('Enter note name: ')
      note_name = ''

      loop do
        input = @user_interface.bottom_bar_input

        return unless input

        case input
        when 10, 13
          Note.save_note(note_name, @buffer)
          break
        else
          note_name = "#{note_name}#{input}"
          @user_interface.show_on_bottom_bar(input)
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
  end
end
