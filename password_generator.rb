require_relative './candidate_generator'

class PasswordGenerator
require 'csv'
  SERVICE = 'Cyb'
  CANDIDATE = "Candidate.csv"

  def initialize
    @random = Random.new
  end

  def run
    generate_candidate
    pass = generate_password

    until check_length(pass) do
      pass += add_numbers
    end

    pass
  end

  def generate_candidate
    if !File.exist?(CANDIDATE) then
      generator = CandidateGenerator.new(CANDIDATE)
      generator.run
    end
  end

  def generate_password
    csv_data = CSV.read(CANDIDATE)
    core_pass = csv_data[@random.rand(csv_data.count - 1)].to_s.delete('[').delete(']').delete('"')

    upcase_string = core_pass.slice(@random.rand(core_pass.length - 1))
    core_pass = core_pass.gsub(/(#{upcase_string})/, upcase_string.upcase) + add_numbers

    SERVICE + core_pass
  end

  def check_length(pass)
    return true if pass.length > 8
    false
  end

  def add_numbers
    @random.rand(10).to_s
  end
end