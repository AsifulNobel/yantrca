# frozen_string_literal: true

require_relative 'lib/app'

if __FILE__ == $PROGRAM_NAME
  app = Yantrca::App.new

  begin
    app.start
  rescue StandardError => e
    File.open('logs/errors.txt', 'w') do |f|
      f << e.message
      f << e.backtrace
      f << "\n"
    end
  ensure
    app.stop
  end
end
