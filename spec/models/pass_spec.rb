require 'spec_helper'

describe Pass do
  [:pass_number, :total_vertical_feet, :total_days, :total_runs].each do |attr|
    it{ should respond_to(attr) }
  end
  it{ should belong_to(:shredder) }
end
