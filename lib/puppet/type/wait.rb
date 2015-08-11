Puppet::Type.newtype(:wait) do

  ensurable

  newparam(:name) do
    desc "name."
  end

  newparam(:sec) do
    munge do |value|
      Puppet.notice 'Converting sec to integer'
      value.to_i
    end
  end
end