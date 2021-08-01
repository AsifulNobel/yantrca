# frozen_string_literal: true

require 'json'

module Yantrca
  module Note
    DIRECTORY = 'notes'

    def self.existing_notes
      File.open(notes_list_path, 'r') do |f|
        JSON.parse(f.read, { symbolize_names: true })
      end
    rescue Errno::ENOENT
      []
    end

    def self.add_note(name, text)
      notes = existing_notes

      return false if notes.any? { |note| note[:name] == name }

      file_path = File.join(DIRECTORY, "#{SecureRandom.uuid}.txt")
      File.open(file_path, 'w') { |f| f.write(text) }
      notes.push({ name: name, path: file_path })

      File.open(notes_list_path, 'w') { |f| JSON.dump(notes, f) }
      true
    end

    def self.notes_list_path
      File.join(DIRECTORY, 'list.json')
    end

    private_class_method :notes_list_path
  end
end
