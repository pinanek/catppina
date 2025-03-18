_default:
    @just --list

theme_name := 'catppina'

theme_variant := 'mocha'
theme_accent := 'blue'

color_overrides_file := justfile_directory() / 'color_overrides.json'
color_overrides := shell('echo $(cat $1)', color_overrides_file)
color_overrides_without_hashtag := shell("echo $(echo $1 | sed 's/#//g')", color_overrides)

scripts_dir := justfile_directory() / 'scripts'
dist_dir := justfile_directory() / 'dist'
temp_dir := justfile_directory() / '.temp'

@prepare:
  echo -n 'Preparing...'

  rm -rf {{temp_dir}}
  cp -r ports {{temp_dir}}

  rm -rf {{dist_dir}}

  echo ' done!'

@clean:
  rm -rf {{temp_dir}}

@build_bat:
  echo -n 'Building bat...'

  mkdir -p {{dist_dir}}/bat

  cd {{temp_dir}}/bat && deno task build --color-overrides '{{color_overrides}}'
  mv {{temp_dir}}/bat/themes/Catppuccin\ Mocha.tmTheme {{dist_dir}}/bat/{{theme_name}}.tmTheme

  echo ' done!'

@build_fish:
  echo -n 'Building fish...'

  mkdir -p {{dist_dir}}/fish

  cd {{temp_dir}}/fish \
    && whiskers fish.tera --color-overrides '{{color_overrides_without_hashtag}}'
  mv {{temp_dir}}/fish/themes/Catppuccin\ Mocha.theme {{dist_dir}}/fish/{{theme_name}}.theme

  echo ' done!'

@build_fzf:
  echo -n 'Building fzf...'

  mkdir -p {{dist_dir}}/fzf

  cd {{temp_dir}}/fzf \
    && whiskers fzf.tera --color-overrides '{{color_overrides_without_hashtag}}'
  python3 {{scripts_dir}}/fzf.py {{temp_dir}}/fzf/README.md > {{dist_dir}}/fzf/{{theme_name}}.fish

  echo ' done!'

@build_ghostty:
  echo -n 'Building ghostty...'

  mkdir -p {{dist_dir}}/ghostty

  cd {{temp_dir}}/ghostty \
    && whiskers ghostty.tera --color-overrides '{{color_overrides_without_hashtag}}'
  mv {{temp_dir}}/ghostty/themes/catppuccin-mocha.conf {{dist_dir}}/ghostty/{{theme_name}}.conf

  echo ' done!'

@build_helix:
  echo -n 'Building helix...'

  mkdir -p {{dist_dir}}/helix

  cd {{temp_dir}}/helix \
    && whiskers helix.tera --color-overrides '{{color_overrides_without_hashtag}}'
  mv {{temp_dir}}/helix/themes/default/catppuccin_mocha.toml {{dist_dir}}/helix/{{theme_name}}.toml

  echo ' done!'

@build_yazi:
  echo -n 'Building yazi...'

  mkdir -p {{dist_dir}}/yazi

  cd {{temp_dir}}/yazi \
    && whiskers yazi.tera --color-overrides '{{color_overrides_without_hashtag}}'
  mv {{temp_dir}}/yazi/themes/{{theme_variant}}/catppuccin-mocha-{{theme_accent}}.toml {{dist_dir}}/yazi/{{theme_name}}.toml

  echo ' done!'

@build_zellij:
  echo -n 'Building zellij...'

  mkdir -p {{dist_dir}}/zellij

  cd {{temp_dir}}/zellij \
    && whiskers zellij.tera --color-overrides '{{color_overrides_without_hashtag}}'
  mv {{temp_dir}}/zellij/catppuccin.kdl {{dist_dir}}/zellij/{{theme_name}}.kdl
  python3 {{scripts_dir}}/zellij.py {{temp_dir}}/zellij/catppuccin.kdl > {{dist_dir}}/zellij/{{theme_name}}.kdl

  echo ' done!'

build: prepare \
  build_bat \
  build_fish \
  build_fzf \
  build_ghostty \
  build_helix \
  build_yazi \
  build_zellij \
  clean
