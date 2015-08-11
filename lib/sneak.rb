module Sneak
  def self.included base
    base.instance_eval do
      def self.new(*args, &block)
        obj = self.allocate
        Puppet.warning "`#{self}` #{obj.object_id} allocated"

        obj.send :initialize, *args, &block
        Puppet.err '#{self} ======> args.length != 1' if args.length != 1

        the_class = args[0].class == Hash ? "Hash of #{args[0][:resource].class}" : args[0].class
        object_id = args[0].class == Hash ? args[0][:resource].object_id : args[0].object_id
        thing_to_print = args[0].class == Hash ? args[0].keys : args[0].class == Puppet::Resource ? args[0].inspect : args[0].to_s
        Puppet.warning "`#{self}` #{obj.object_id} initialized with: '#{the_class}', object_id: '#{object_id}'" #, #{thing_to_print}"

        obj
      end
    end
  end
end