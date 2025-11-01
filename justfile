_default:
    @just --list

theme := 'catppina'
theme_variant := 'mocha'
theme_accent := 'blue'
colors := read(justfile_directory() / 'colors.json')
colors_nh := shell("echo $(echo $1 | sed 's/#//g')", colors)
dist_dir := justfile_directory() / 'dist'
temp_dir := justfile_directory() / '.temp'

# Utils

@_run_build_deno target src ext:
    echo -n "Building {{ target }}..."

    mkdir -p {{ dist_dir }}/{{ target }}
    cd {{ temp_dir }}/{{ target }} && deno task build --color-overrides {{ quote(colors) }}
    mv "{{ temp_dir }}/{{ target }}/{{ src }}" "{{ dist_dir }}/{{ target }}/{{ theme }}.{{ ext }}"

    echo " done!"

@_run_build_python target src ext:
    echo -n "Building {{ target }}..."

    mkdir -p {{ dist_dir }}/{{ target }}
    cd {{ temp_dir }}/{{ target }} && whiskers {{ target }}.tera --color-overrides {{ quote(colors_nh) }}
    python3 scripts/{{ target }}.py "{{ temp_dir }}/{{ target }}/{{ src }}" {{ theme }} > "{{ dist_dir }}/{{ target }}/{{ theme }}.{{ ext }}"

    echo " done!"

@_run_build_whiskers target src ext:
    echo -n "Building {{ target }}..."

    mkdir -p {{ dist_dir }}/{{ target }}
    cd {{ temp_dir }}/{{ target }} && whiskers {{ target }}.tera --color-overrides {{ quote(colors_nh) }}
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
    just --justfile "{{ justfile() }}" _run_build_deno \
      'bat' \
      'themes/Catppuccin Mocha.tmTheme' \
      'tmTheme'

@build_btop:
    just --justfile "{{ justfile() }}" _run_build_whiskers \
      'btop' \
      'themes/catppuccin_mocha.theme' \
      'theme'

@build_delta:
    just --justfile "{{ justfile() }}" _run_build_python \
      'delta' \
      'catppuccin.gitconfig' \
      'gitconfig'

@build_fish:
    just --justfile '{{ justfile() }}' _run_build_whiskers \
      'fish' \
      'themes/Catppuccin Mocha.theme' \
      'theme'

@build_fzf:
    just --justfile '{{ justfile() }}' _run_build_whiskers \
      'fzf' \
      'themes/catppuccin-fzf-mocha.fish' \
      'fish'

@build_ghostty:
    just --justfile '{{ justfile() }}' _run_build_whiskers \
      'ghostty' \
      'themes/catppuccin-mocha.conf' \
      'conf'

@build_helix:
    just --justfile '{{ justfile() }}' _run_build_whiskers \
      'helix' \
      'themes/default/catppuccin_mocha.toml' \
      'toml'

@build_lazygit:
    just --justfile '{{ justfile() }}' _run_build_whiskers \
      'lazygit' \
      'themes/{{ theme_variant }}/{{ theme_accent }}.yml' \
      'yml'

@build_yazi:
    just --justfile '{{ justfile() }}' _run_build_whiskers \
      'yazi' \
      'themes/{{ theme_variant }}/catppuccin-mocha-{{ theme_accent }}.toml' \
      'toml'

@build_zsh_syntax_highlighting:
    just --justfile '{{ justfile() }}' _run_build_whiskers \
      'zsh-syntax-highlighting' \
      'themes/catppuccin_mocha-zsh-syntax-highlighting.zsh' \
      'zsh'

build: prepare build_bat build_btop build_delta build_fish build_fzf build_ghostty build_helix build_lazygit build_yazi build_zsh_syntax_highlighting clean
