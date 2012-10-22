require 'spec_helper'

describe SmsAction do
  it{ should belong_to(:area) }
  it{ should belong_to(:chair) }
  it{ should respond_to(:command) }
end
