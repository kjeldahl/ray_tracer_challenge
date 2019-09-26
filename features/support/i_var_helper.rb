# Adds Methods for accessing instanve variables using strings names
module IVarHelper

  def get(s)
    @variables ||= {}
    @variables.fetch("@#{valid_instance_name(s)}")
  end

  def set(s, v)
    @variables ||= {}
    @variables["@#{valid_instance_name(s)}"] = v
  end

  protected
  def valid_instance_name(s)
    case s
      when /\A\d+.*/
        "_#{s}"
      else
       s
    end
  end
end