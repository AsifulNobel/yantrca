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

    def self.delete_note(name)
      notes = existing_notes
      note = notes.find { |existing_note| existing_note[:name] == name }
      return false unless note

      begin
        File.delete(File.expand_path(note[:path]))
      rescue Errno::ENOENT
        # File already deleted
      end

      notes = notes.reject { |existing_note| existing_note[:name] == name }
      File.open(notes_list_path, 'w') { |f| JSON.dump(notes, f) }
      true
    end

    def self.notes_list_path
      File.join(DIRECTORY, 'list.json')
    end

    def self.note(name)
      notes = existing_notes
      note = notes.find { |existing_note| existing_note[:name] == name }

      return '' unless note

      File.open(note[:path], 'r') { |f| f&.read() }
    end

    def self.update_note(name, text)
      notes = existing_notes
      note = notes.find { |existing_note| existing_note[:name] == name }

      return false unless note

      File.open(note[:path], 'w') { |f| f.write(text) }
      true
    end

    private_class_method :notes_list_path
  end
end
