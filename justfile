set default-list := true

# Configuration

theme := 'catppina'
theme_variant := 'mocha'
theme_accent := 'blue'

root_dir := justfile_directory()
ports_dir := root_dir / 'ports'
dist_dir := root_dir / 'dist'
temp_dir := root_dir / '.temp'
scripts_dir := root_dir / 'scripts'

colors := read(root_dir / 'colors.json')
colors_no_hash := replace(colors, '#', '')

# Internal recipes

@_prepare_target target:
    rm -rf \
        {{ quote(temp_dir / target) }} \
        {{ quote(dist_dir / target) }}

    mkdir -p \
        {{ quote(temp_dir) }} \
        {{ quote(dist_dir) }}

    cp -R \
        {{ quote(ports_dir / target) }} \
        {{ quote(temp_dir / target) }}

@_build_deno target source extension: (_prepare_target target)
    echo -n 'Building {{ target }}...'

    mkdir -p {{ quote(dist_dir / target) }}

    cd {{ quote(temp_dir / target) }} && \
        deno task build \
            --color-overrides {{ quote(colors) }}

    mv \
        {{ quote(temp_dir / target / source) }} \
        {{ quote(dist_dir / target / (theme + '.' + extension)) }}

    echo ' done!'

@_build_whiskers target source extension: (_prepare_target target)
    echo -n 'Building {{ target }}...'

    mkdir -p {{ quote(dist_dir / target) }}

    cd {{ quote(temp_dir / target) }} && \
        whiskers \
            {{ quote(target + '.tera') }} \
            --color-overrides {{ quote(colors_no_hash) }}

    mv \
        {{ quote(temp_dir / target / source) }} \
        {{ quote(dist_dir / target / (theme + '.' + extension)) }}

    echo ' done!'

@_build_python target source extension: (_prepare_target target)
    echo -n 'Building {{ target }}...'

    mkdir -p {{ quote(dist_dir / target) }}

    cd {{ quote(temp_dir / target) }} && \
        whiskers \
            {{ quote(target + '.tera') }} \
            --color-overrides {{ quote(colors_no_hash) }}

    python3 \
        {{ quote(scripts_dir / (target + '.py')) }} \
        {{ quote(temp_dir / target / source) }} \
        {{ quote(theme) }} \
        > {{ quote(dist_dir / target / (theme + '.' + extension)) }}

    echo ' done!'

# Lifecycle

@prepare:
    echo -n 'Preparing...'

    rm -rf \
        {{ quote(temp_dir) }} \
        {{ quote(dist_dir) }}

    mkdir -p \
        {{ quote(temp_dir) }} \
        {{ quote(dist_dir) }}

    echo ' done!'

@clean:
    rm -rf {{ quote(temp_dir) }}

# Targets

build_bat: (_build_deno \
    'bat' \
    'themes/Catppuccin Mocha.tmTheme' \
    'tmTheme')

build_btop: (_build_whiskers \
    'btop' \
    'themes/catppuccin_mocha.theme' \
    'theme')

build_delta: (_build_python \
    'delta' \
    'catppuccin.gitconfig' \
    'gitconfig')

build_fish: (_build_whiskers \
    'fish' \
    'themes/catppuccin-mocha.theme' \
    'theme')

build_fzf: (_build_whiskers \
    'fzf' \
    'themes/catppuccin-fzf-mocha.sh' \
    'sh')

build_ghostty: (_build_whiskers \
    'ghostty' \
    'themes/catppuccin-mocha.conf' \
    'conf')

build_helix: (_build_whiskers \
    'helix' \
    'themes/default/catppuccin_mocha.toml' \
    'toml')

build_lazygit: (_build_whiskers \
    'lazygit' \
    'themes-mergable/{{ theme_variant }}/{{ theme_accent }}.yml' \
    'yml')

build_yazi: (_build_whiskers \
    'yazi' \
    'themes/{{ theme_variant }}/catppuccin-mocha-{{ theme_accent }}.toml' \
    'toml')

build_zed: (_build_python \
    'zed' \
    'themes/catppuccin-mauve.json' \
    'json')

build_zsh_syntax_highlighting: (_build_whiskers \
    'zsh-syntax-highlighting' \
    'themes/catppuccin_mocha-zsh-syntax-highlighting.zsh' \
    'zsh')

# Aggregate build

@_build_all: \
    build_bat \
    build_btop \
    build_delta \
    build_fish \
    build_fzf \
    build_ghostty \
    build_helix \
    build_lazygit \
    build_yazi \
    build_zed \
    build_zsh_syntax_highlighting \
    && clean

build: prepare && _build_all
