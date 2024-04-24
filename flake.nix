{
  description = ''
    Opinionated flake templates for different developement environments.

    Use `nix flake new -t github:sgrimee/flate-templates#language` to use the template
  '';
  outputs = self: rec {
    templates = {

      python = {
        path = ./python;
        description = "Python template";
      };

      rust-fenix = {
        path = ./rust-fenix;
        description = "Rust template with fenix";
      };

      rust-cuda = {
        path = ./rust-cuda;
        description = "Rust template with GPU acceleration for Mac and Linux";
      };

    defaultTemplate = templates.python;
  };
}
