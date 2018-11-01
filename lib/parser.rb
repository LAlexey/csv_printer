require 'rubygems/package'
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'pry-byebug'
end

require 'csv'
require_relative 'parser/table'
require_relative 'parser/printer'

class Parser
  attr_reader :file_path

  def self.from(file_path)
    new(file_path).print
  end

  def initialize(file_path)
    @file_path = file_path
  end

  def print
    fill_table
    print_table
  end

  def fill_table
    CSV.foreach(file_path, headers: true, header_converters: :symbol, col_sep: ';').with_index do |csv, i|
      table.init_columns(csv.headers) if i.zero?
      table.add_row(csv.fields)
    end
  end

  def print_table
    Printer.new(table).print
  end

  def table
    @table ||= Table.new
  end
end
