# frozen_string_literal: true

require 'curses'

module Yantrca
  # Class to let the state's interact with terminal screen easily
  class UI
    def initialize
      @screen = Curses.init_screen
      initialize_default_styles
      initialize_windows
    end

    def close
      @menu&.unpost
      @top_bar.close
      @middle_window.close
      @bottom_bar.close
      Curses.close_screen
    end

    def clear_top_bar
      @top_bar.clear
      @top_bar.refresh
    end

    def clear_content
      @content_section.clear
    end

    def clear_bottom_bar
      @bottom_bar.clear
      @bottom_bar.refresh
    end

    def clear
      clear_top_bar
      clear_content
      clear_bottom_bar
    end

    def top_bar_title=(text)
      return unless text

      @top_bar.standout
      @top_bar << text.center(Curses.cols)
      @top_bar.standend
      @top_bar.refresh
    end

    def user_input(window)
      ch = window.getch

      case ch
      when 3
        nil
      else
        ch
      end
    end

    def content_input
      user_input(@content_section)
    end

    def bottom_bar_input
      user_input(@bottom_bar)
    end

    def show_content(text)
      @content_section << text
    end

    def show_on_bottom_bar(text)
      @bottom_bar << text
    end

    def show_cursor
      Curses.curs_set(1)
    end

    def hide_cursor
      Curses.curs_set(0)
    end

    def show_actions_on_bottom_bar(actions)
      actions.each do |action_key_stroke, action_description|
        @bottom_bar.standout
        @bottom_bar << "#{action_key_stroke} "
        @bottom_bar.standend
        @bottom_bar << " - #{action_description} "
      end
      @bottom_bar.refresh
    end

    def show_menu(items)
      remove_menu_if_exists
      @menu = Curses::Menu.new(menu_items(items))
      @menu.opts_off(Curses::O_SHOWDESC)
      @menu.set_sub(@content_section)
      @menu.post
    end

    def select_previous_item
      @menu.up_item
    end

    def select_next_item
      @menu.down_item
    end

    def current_menu_note_name
      @menu.current_item.description
    end

    def remove_menu_if_exists
      @menu&.unpost
      @menu = nil
    end

    private

    def initialize_default_styles
      Curses.noecho
      Curses.raw
      Curses.nonl
      show_cursor
    end

    def initialize_windows
      @top_bar = draw_top_bar
      @middle_window = draw_middle_window
      @content_section = draw_content_section(@middle_window)
      @content_section.keypad = true
      @bottom_bar = draw_bottom_bar
      @bottom_bar.keypad = true
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
      sub_window = parent_window.derwin(Curses.lines - 4, Curses.cols - 2, 1, 1)
      sub_window.refresh
      sub_window
    end

    def draw_bottom_bar
      window = Curses::Window.new(1, Curses.cols, Curses.lines - 1, 0)
      window.refresh
      window
    end

    def menu_items(items)
      items.map do |item_text|
        item_name = if item_text.length > Curses.cols - 2
                      "#{item_text.slice(0, Curses.cols - 5)}..."
                    else
                      item_text.ljust(Curses.cols - 2)
                    end
        Curses::Item.new(item_name, item_text)
      end
    end
  end
end
