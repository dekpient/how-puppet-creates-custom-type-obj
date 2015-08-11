Puppet::Type.type(:wait).provide(:ruby) do

  def exists?
    false
  end

  def create
    Puppet.notice "Waiting for #{resource[:sec]} secs"
    sleep resource[:sec]
  end
  
end