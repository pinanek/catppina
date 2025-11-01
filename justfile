_default:
    @just --list

theme := 'catppina'
theme_variant := 'mocha'
theme_accent := 'blue'
colors_file := justfile_directory() / 'colors.json'
colors := shell('echo $(cat $1)', colors_file)
colors_nh := shell("echo $(echo $1 | sed 's/#//g')", colors)
dist_dir := justfile_directory() / 'dist'
temp_dir := justfile_directory() / '.temp'

# Utils

@_build target cmd src ext:
    echo -n "Building {{ target }}..."

    mkdir -p {{ dist_dir }}/{{ target }}
    cd {{ temp_dir }}/{{ target }} && {{ cmd }}
    mv "{{ temp_dir }}/{{ target }}/{{ src }}" "{{ dist_dir }}/{{ target }}/{{ theme }}.{{ ext }}"

    echo " done!"

# Recipes

@prepare:
    echo -n 'Preparing...'

    rm -rf {{ temp_dir }}
    cp -r ports {{ temp_dir }}

    rm -rf {{ dist_dir }}

    echo ' done!'

@clean:
    rm -rf {{ temp_dir }}

@build_bat:
    @_build \
      bat \
      "deno task build --color-overrides '{{ colors }}'" \
      "themes/Catppuccin Mocha.tmTheme" \
      tmTheme

@build_btop:
    @_build \
      btop \
      "whiskers btop.tera --color-overrides '{{ colors_nh }}'" \
      "themes/catppuccin_mocha.theme" \
      theme

@build_fish:
    @_build \
      fish \
      "whiskers fish.tera --color-overrides '{{ colors_nh }}'" \
      "themes/Catppuccin Mocha.theme" \
      theme

@build_fzf:
    @_build \
      fzf \
      "whiskers fzf.tera --color-overrides '{{ colors_nh }}'" \
      "themes/catppuccin-fzf-mocha.fish" \
      fish

@build_ghostty:
    @_build \
      ghostty \
      "whiskers ghostty.tera --color-overrides '{{ colors_nh }}'" \
      "themes/catppuccin-mocha.conf" \
      conf

@build_helix:
    @_build \
      helix \
      "whiskers helix.tera --color-overrides '{{ colors_nh }}'" \
      "themes/default/catppuccin_mocha.toml" \
      toml

@build_lazygit:
    @_build \
      lazygit \
      "whiskers lazygit.tera --color-overrides '{{ colors_nh }}'" \
      "themes/{{ theme_variant }}/{{ theme_accent }}.yml" \
      yml

@build_yazi:
    @_build \
      yazi \
      "whiskers yazi.tera --color-overrides '{{ colors_nh }}'" \
      "themes/{{ theme_variant }}/catppuccin-mocha-{{ theme_accent }}.toml" \
      toml

@build_zsh_syntax_highlighting:
    @_build \
      zsh-syntax-highlighting \
      "whiskers zsh-syntax-highlighting.tera --color-overrides '{{ colors_nh }}'" \
      "themes/catppuccin_mocha-zsh-syntax-highlighting.zsh" \
      zsh

build: prepare build_bat build_btop build_fish build_fzf build_ghostty build_helix build_lazygit build_yazi build_zsh_syntax_highlighting clean
