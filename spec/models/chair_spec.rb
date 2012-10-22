require 'spec_helper'

describe Chair do
  it{ should belong_to(:area) }
  it{ should respond_to(:short_code) }
  it{ should respond_to(:name) }
  it{ should respond_to(:status) }
end
