require 'spec_helper'

describe Alert do
  it{ should belong_to(:snow_report) }
  it{ should belong_to(:shredder) }
  it{ should belong_to(:area) }

  describe 'send_message' do

  end
end
