# frozen_string_literal: true

require 'curses'

module Yantrca
  class UI
    def initialize
      @screen = Curses.init_screen
      initialize_default_styles
      initialize_windows
    end

    def close
      @top_bar.close
      @middle_window.close
      @bottom_bar.close
      Curses.close_screen
    end

    def clear_top_bar
      @top_bar.clear
    end

    def clear_content
      @content_section.clear
    end

    def clear_bottom_bar
      @bottom_bar.clear
    end

    def clear
      clear_top_bar
      clear_content
      clear_bottom_bar
    end

    def top_bar_title=(text)
      @top_bar.standout
      @top_bar << text&.center(Curses.cols)
      @top_bar.standend
      @top_bar.refresh
    end

    def user_input
      @content_section.getch
    end

    private

    def initialize_default_styles
      Curses.noecho
      Curses.raw
      Curses.nonl
      Curses.curs_set(1)
    end

    def initialize_windows
      @top_bar = draw_top_bar
      @middle_window = draw_middle_window
      @content_section = draw_content_section(@middle_window)
      @bottom_bar = draw_bottom_bar
    end

    def draw_top_bar
      window = Curses::Window.new(1, Curses.cols, 0, 0)
      window.refresh
      window
    end

    def draw_middle_window
      window = Curses::Window.new(Curses.lines - 2, Curses.cols, 1, 0)
      window.box('|', '-', '+') # border
      window.refresh
      window
    end

    def draw_content_section(parent_window)
      parent_window.derwin(Curses.lines - 4, Curses.cols - 2, 1, 1)
    end

    def draw_bottom_bar
      window = Curses::Window.new(1, Curses.cols, Curses.lines - 1, 0)
      window.refresh
      window
    end
  end
end
