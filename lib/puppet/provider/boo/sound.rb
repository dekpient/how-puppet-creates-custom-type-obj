Puppet::Type.type(:boo).provide(:sound) do

  def exists?
    false
  end

  def create
    Puppet.notice "BOOOO!!! #{resource[:lol].upcase}"
   
    resource[:refresh_session].each { |r| r.refresh_session resource[:name] } if resource[:refresh_session]
  end
  
end