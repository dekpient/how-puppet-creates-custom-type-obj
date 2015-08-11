require 'spec_helper'
describe 'sweet' do

  context 'with defaults for all parameters' do
    it { should contain_class('sweet') }
  end
end
