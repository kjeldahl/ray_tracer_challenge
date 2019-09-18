# Adds Methods for accessing instanve variables using strings names
module IVarHelper

  def i_get(s)
    instance_variable_get("@#{valid_instance_name(s)}")
  end

  def i_set(s, v)
    instance_variable_set("@#{valid_instance_name(s)}", v)
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