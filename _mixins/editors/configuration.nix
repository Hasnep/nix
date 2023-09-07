{
  lib,
  config,
  ...
}: let
  username = config.mixins.default.username;
in {
  options.mixins.editors = {
    micro = {
      enable = lib.mkEnableOption (lib.mdDoc "micro");
    };
    helix = {
      enable = lib.mkEnableOption (lib.mdDoc "helix");
    };
    defaultEditor = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    home-manager.users.${username} = {
      # Default editor
      home.sessionVariables = {EDITOR = config.mixins.editors.defaultEditor;};

      # Micro
      programs.micro.enable = config.mixins.editors.micro.enable;

      # Helix
      programs.helix = {
        enable = config.mixins.editors.helix.enable;
        languages = {
          language = [
            {
              name = "rust";
              auto-format = true;
            }
          ];
        };
        settings = {};
        themes = {};
      };

      # # VSCode
      # programs.vscode.enable = true;

      # Editor config
      editorconfig = {
        enable = true;
        settings = {
          "*" = {
            charset = "utf-8";
            end_of_line = "lf";
            trim_trailing_whitespace = true;
            insert_final_newline = true;
          };
          # Crystal
          "*.cr" = {
            indent_style = "space";
            indent_size = 2;
          };
          # C#
          "*.cs" = {
            indent_style = "space";
            indent_size = 4;
          };
          # Fish
          "*.fish" = {
            indent_style = "space";
            indent_size = 4;
          };
          # GDScript
          "*.gd" = {
            indent_style = "tab";
          };
          # JSON, JSONC
          "*.{json,jsonc}" = {
            indent_style = "space";
            indent_size = 2;
          };
          # Julia
          "*.jl" = {
            indent_style = "space";
            indent_size = 4;
          };
          # Makefiles
          "Makefile" = {
            indent_style = "tab";
            tab_width = 4;
          };
          # Markdown
          "*.md" = {
            indent_style = "space";
            indent_size = 2;
          };
          # Nim
          "*.nim" = {
            indent_style = "space";
            indent_size = 2;
          };
          # Ninja
          "*.ninja" = {
            indent_style = "space";
            indent_size = 2;
          };
          # Nix
          "*.nix" = {
            indent_style = "space";
            indent_size = 2;
          };
          # Python
          "*.py" = {
            indent_style = "space";
            indent_size = 4;
          };
          # Rust
          "*.rs" = {
            indent_style = "space";
            indent_size = 2;
          };
          # YAML
          "*.yaml" = {
            indent_style = "space";
            indent_size = 2;
          };
        };
      };
    };
  };
}
