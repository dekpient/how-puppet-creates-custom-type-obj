require_relative '../../sneak.rb'

Puppet::Type.newtype(:stuff) do
  @doc = "Do stuff"

  Puppet.notice "Defining stuff"
  Puppet.debug "DEBUG Puppet #{Puppet.methods.sort}"
  Puppet.info "DEBUG stuff type '#{self.class}' #{self}"

  self.send(:include, Sneak)

  # def self.new

  ensurable
  # do
  #   newvalue(:absent)
  #   newvalue(:shitty) do
  #     provider.turn_to_shit
  #   end

  #   newvalue(:eaten) do
  #     provider.eat
  #     puts should(:color)
  #     def insync?(is)
  #       'eaten' == should
  #     end
  #   end

  # end

  newparam(:name) do
    desc "name."
    Puppet.notice "Defining stuff's name"
    Puppet.info "DEBUG :name type '#{self.class}' #{self}"
    Puppet.debug "DEBUG :name included_modules: #{self.included_modules}"
    self.send(:include, Sneak)
  end

  newparam(:smell_level) do
    desc "1 to 10, demicals not allowed"
    defaultto '5'
    Puppet.notice "Defining stuff's smell_level"
    Puppet.info "DEBUG :smell_level type '#{self.class}' #{self}"
    Puppet.debug "DEBUG :smell_level included_modules: #{self.included_modules}"
    self.send(:include, Sneak)

    validate do |value|
      Puppet.info "DEBUG :smell_level#validate? #{self.class}"
      Puppet.notice "Validating smell_level: #{value}"
      raise ArgumentError, "Be whole!" if value.is_a?(String) and value.include?(".")
    end

    munge do |value|
      Puppet.notice "Munging smell_level"
      value.to_i + 1 # bonus point
    end
  end

  newproperty(:color) do
    newvalues(:red, :blue)
    # newvalue(:red) do
    #   provider.make_it_red
    # end
    self.send(:include, Sneak)
  end

  newproperty(:owner) do
    desc "own it"
    newvalue(:ing)
    newvalue(:no_one)
    Puppet.notice "Defining stuff's owner"
    Puppet.info "DEBUG :owner type '#{self.class}' #{self}"
    Puppet.debug "DEBUG :owner included_modules: #{self.included_modules}"
    self.send(:include, Sneak)
  end

  newproperty(:names, :array_matching => :all) do
    desc "all the names it's get called"
    Puppet.info "DEBUG :names #{self}"
    self.send(:include, Sneak)
    def insync?(is)
      Puppet.info "DEBUG :names#insync? type '#{self.class}'"
      Puppet.notice "Checking if :names of #{resource.name} are insync"
      is.sort == should.sort
    end
  end

end