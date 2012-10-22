require 'spec_helper'

describe Number do
  it{ should belong_to(:area) }
  it{ should respond_to(:inbound) }
end
