Puppet::Type.newtype(:boo) do

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:lol, :namevar => true) do
    desc "lol name."
  end

  newparam(:refresh_session) do
    desc 'lets see'

    def to_type_object(refs)
      refs.collect do |ref|
        if ref.is_a?(Puppet::Resource)
          resource.catalog.resource(ref.ref)
        else
          resource.catalog.resource(ref)
        end
      end
    end

    munge do |ref|
      ref = [ref] unless ref.is_a? Array
      to_type_object(ref)
    end

    validate do |ref|
      ref = [ref] unless ref.is_a? Array
      Puppet.info "Validating things to be refreshed "
      to_type_object(ref).each do |res|
        fail('not magical') unless res && res[:ensure] == :present && res.class == Puppet::Type::Stuff
      end
    end
  end
end