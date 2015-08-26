Puppet::Type.type(:boo).provide(:sound) do

  def exists?
    false
  end

  def create
    Puppet.notice "BOOOO!!!"
   
    resource[:refresh_session].each { |r| r.refresh_session resource[:name] }
  end
  
end