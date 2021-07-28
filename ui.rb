# frozen_string_literal: true

require 'curses'

module UI
  class Terminal
    def initialize
      @screen = Curses.init_screen

      initialize_default_styles
      redraw
    end

    def redraw_window(window, &redraw_op)
      if window
        window.close
        redraw_op.call()
      else
        redraw_op.call()
      end
    end

    def redraw
      @top_bar = redraw_window(@top_bar, &-> { draw_top_bar })
      @content_window = redraw_window(@content_window, &-> { draw_content_window })
      @bottom_bar = redraw_window(@bottom_bar, &-> { draw_bottom_bar })

      @note_selection_window = redraw_window(@note_selection_window, &-> { draw_note_selection_content_subwindow(@content_window) })
      @note_selection_window.keypad = true
      populate_notes_menu(@notes)
    end

    def initialize_default_styles
      Curses.noecho
      Curses.raw
      Curses.nonl
      Curses.curs_set(1)
    end

    def populate_notes_menu(notes)
      if notes
        current_note_name = @notes_menu&.current_item&.name
        @notes_menu.unpost if @notes_menu

        @notes = notes
        note_title_length = Curses.cols - 2
        @notes_menu = Curses::Menu.new(notes.map do |note|
          item_name = note.length > Curses.cols - 2 ? note.slice(0, Curses.cols - 5) + '...' : note.ljust(Curses.cols - 2)
          Curses::Item.new(item_name, '')
        end)

        @notes_menu.set_sub(@note_selection_window)
        @notes_menu.set_format(Curses.lines - 4, 0)
        @notes_menu.post

        reselect_note(current_note_name) if current_note_name
      end
    end

    def reselect_note(note_name)
      item_count = @notes_menu.item_count
      @notes_menu.items.each_with_index do |item, index|
        if item.name.strip == note_name.strip
          return
        elsif index < item_count - 1
          # No need to select next item, if already on last item
          @notes_menu.down_item
        end
      end
    end

    def wait_for_note_selection_user_input
      input = get_user_input(@note_selection_window)

      begin
        case input
        when Curses::KEY_UP
          @notes_menu.up_item
        when Curses::KEY_DOWN
          @notes_menu.down_item
        when Curses::KEY_LEFT
          @notes_menu.left_item
        when Curses::KEY_RIGHT
          @notes_menu.right_item
        end
      rescue Curses::RequestDeniedError
      end
    end

    def output_highlighted(window, &output)
      window.attron(Curses::A_STANDOUT)
      output.call()
      window.attroff(Curses::A_STANDOUT)
    end

    def draw_top_bar
      top_bar = Curses::Window.new(1, Curses.cols, 0, 0)
      text = "Yet Another Note Taking Console App 📓️"

      output_highlighted(top_bar, &-> { top_bar << text.center(Curses.cols) })

      top_bar.refresh
      top_bar
    end

    def draw_bottom_bar
      bottom_bar = Curses::Window.new(1, Curses.cols, Curses.lines - 1, 0)
      output_highlighted(bottom_bar, &-> { bottom_bar << "^C" })
      bottom_bar << " - Exit"
      bottom_bar.refresh
      bottom_bar
    end

    def draw_content_window
      window = Curses::Window.new(Curses.lines - 2, Curses.cols, 1, 0)
      window.box("|", "-", "#")
      window.refresh
      window
    end

    def get_content_subwindow(parent_window)
      parent_window.subwin(Curses.lines - 4, Curses.cols - 2, 2, 1)
    end

    def draw_note_selection_content_subwindow(parent_window)
      sub_window = get_content_subwindow(parent_window)
      sub_window.refresh
      sub_window
    end

    def get_user_input(window)
      input = window.getch

      case input
      when Curses::KEY_RESIZE
        redraw
      when 3 # Interrupt
        close
        exit
      else
        input
      end
    end

    def close
      Curses.close_screen
    end
  end
end
