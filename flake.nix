{
  description = "A flake template";

  outputs = _: {
    templates.default = {
      path = ./template;
      description = "A general purpose flake";
    };
  };
}
