require_relative '../../../sneak.rb'

Puppet::Type.type(:stuff).provide(:rubbish) do
  commands :list => 'ls'

  self.send(:include, Sneak)

  Puppet.notice "Defining rubbish"
  Puppet.info "DEBUG :rubbish #{self.class}"
  Puppet.info "DEBUG :rubbish #{self}"
  Puppet.debug "DEBUG :rubbish ancestors: #{self.class.ancestors}"
  Puppet.debug "DEBUG :rubbish methods: #{self.methods.sort}"
  Puppet.debug "DEBUG :rubbish included_modules: #{self.included_modules}"

  def exists?
    Puppet.info "DEBUG rubbish#exists? #{self.class}"
    Puppet.debug "DEBUG rubbish#exists?methods: #{self.methods.sort}"
    Puppet.debug "DEBUG rubbish#exists? ancestors: #{self.class.ancestors}"
    # Puppet.info "DEBUG rubbish#exists? #{self.included_modules}"

    Puppet.notice "Checking if #{resource[:name]} exists..."
    rubbish.include? resource[:name]
    resource[:name] == 'magic'
  end

  def create
    Puppet.notice "Go create #{resource[:name]} in ~"
    rubbish.include? 'hi'
  end

  # def destroy
  #   Puppet.notice "Destroyyyy #{resource[:name]}"
  # end

  def turn_to_shit
  	Puppet.notice "#{resource[:name]} becomes shitty"
  end

  def eaten_by(who)
  	Puppet.notice "#{resource[:name]} has been chewed and swallowed by #{who.upcase}"
  end

  def names
    ['dekpient', 'ing']
    # [ing']
  end

  def names=(value)
    Puppet.notice "Setting names of #{resource[:name]} to #{value}"
  end

  def color
    Puppet.notice "Checking color of #{resource[:name]}"
    'none'
  end

  def color=(value)
  	Puppet.notice "#{resource[:name]} is now #{value}!"
  end

  def rubbish
    Puppet.notice "└-- Try to find rubbish for #{resource[:name]}"
    @rubbish ||= get_rubbish
  end

  def get_rubbish
    Puppet.notice("  └-- Getting fresh rubbish for #{resource[:name]}")
  	begin
      output = list(['-1', '/home/ing'])
    rescue Puppet::ExecutionFailure => e
      Puppet.notice("#get_rubbish had an error -> #{e.inspect}")
      return nil
    end
    rubbish = output.split("\n").sort
    return nil if rubbish.first =~ /There isn\'t any rubbish/
    rubbish
  end

end