# frozen_string_literal: true

require 'curses'

module UI
  class Terminal
    def initialize
      @screen = Curses.init_screen

      initialize_default_styles

      @top_bar = draw_top_bar
      @content_window = draw_content_window
      @bottom_bar = draw_bottom_bar

      @note_selection_window = draw_note_selection_content_subwindow @content_window
    end

    def initialize_default_styles
      Curses.start_color
      Curses.use_default_colors
      Curses.noecho
      Curses.cbreak
    end

    def wait_for_note_selection_user_input
      get_user_input(@note_selection_window)
    end

    def draw_top_bar
      top_bar = Curses::Window.new(1, Curses.cols, 0, 0)
      text = "Yet Another Note Taking Console App"
      # Curses.init_pair(1, 1, 0)
      # top_bar.attron(Curses.color_pair(1))
      top_bar.setpos(0, (Curses.cols - text.length) / 2)
      top_bar << text
      top_bar.refresh
      top_bar
    end

    def draw_bottom_bar
      bottom_bar = Curses::Window.new(1, Curses.cols, Curses.lines - 1, 0)
      bottom_bar << "^C - Exit"
      bottom_bar.refresh
      bottom_bar
    end

    def draw_content_window
      window = Curses::Window.new(Curses.lines - 2, Curses.cols, 1, 0)
      window.box("|", "-", "#")
      window.refresh
      window
    end

    def draw_note_selection_content_subwindow(parent_window)
      sub_window = parent_window.subwin(Curses.lines - 4, Curses.cols - 2, 2, 1)

      sub_window.refresh
      sub_window
    end

    def get_user_input(window)
      loop do
        input = window.getch
        window << input
      end
    end

    def close
      Curses.close_screen
    end
  end
end
