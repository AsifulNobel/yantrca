# frozen_string_literal: true

require 'json'

module Yantrca
  module Note
    DIRECTORY = 'notes'

    def self.existing_notes
      File.open(File.join(DIRECTORY, 'list.json'), 'r') do |f|
        JSON.parse(f.read, { symbolize_names: true })
      end
    rescue Errno::ENOENT
      []
    end

    def self.save_note(name, text)
      file_path = File.join(DIRECTORY, "#{SecureRandom.uuid}.txt")
      File.open(file_path, 'w') { |f| f.write(text) }
      notes = existing_notes
      notes.push({ name: name, path: file_path })

      File.open(File.join(DIRECTORY, 'list.json'), 'w') { |f| JSON.dump(notes, f) }
    end
  end
end
