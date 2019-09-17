# Adds Methods for accessing instanve variables using strings names
module IVarHelper

  def i_get(s)
    instance_variable_get("@#{s}")
  end

  def i_set(s, v)
    instance_variable_set("@#{s}", v)
  end

end