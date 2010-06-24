module Apache

  [
    :DECLINED,
    :DONE,
    :OK,
    :FORBIDDEN,
    :NOT_FOUND
  ].each { |const|
    const_set(const, const) unless const_defined?(const)
  }

end
