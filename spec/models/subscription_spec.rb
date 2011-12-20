require 'spec_helper'

describe Subscription do
  it{ should belong_to(:area) }
  it{ should belong_to(:shredder) }
end
