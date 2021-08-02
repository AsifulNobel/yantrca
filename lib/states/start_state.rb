# frozen_string_literal: true

require_relative '../note'
require_relative 'add_note_state'
require_relative 'update_note_state'

module Yantrca
  # App's starting state
  class StartState
    TITLE = 'Yet Another Note Taking Console App 📓️'

    def initialize(user_interface)
      @user_interface = user_interface
    end

    def activate
      @user_interface.clear
      @user_interface.show_cursor
      @user_interface.top_bar_title = TITLE
      show_existing_notes
      show_available_actions
      process_user_input
    end

    private

    def process_user_input
      loop do
        input = @user_interface.content_input

        return unless input

        case input
        when 1
          return AddNoteState.new(@user_interface)
        when 21
          return UpdateNoteState.new(@user_interface, @user_interface.current_menu_note_name)
        when 4
          delete_note
          next
        when Curses::KEY_UP
          @user_interface.select_previous_item
        when Curses::KEY_DOWN
          @user_interface.select_next_item
        else
          next
        end
      end
    end

    def delete_note
      return unless Note.delete_note(@user_interface.current_menu_note_name)

      show_existing_notes
      @user_interface.clear_bottom_bar
      show_available_actions
    end

    def show_available_actions
      actions = [
        ['^C', 'Exit'],
        ['^A', 'Add Note']
      ]

      unless @notes.empty?
        actions.push(['^U', 'Update Note'])
        actions.push(['^D', 'Delete Note'])
      end

      @user_interface.show_actions_on_bottom_bar(actions)
    end

    def show_existing_notes
      @notes = Note.existing_notes

      if @notes.empty?
        @user_interface.remove_menu_if_exists
        @user_interface.show_content('No Notes Found!')
        @user_interface.hide_cursor
      else
        @user_interface.show_menu(@notes.map { |note| note[:name] })
      end
    end
  end
end
