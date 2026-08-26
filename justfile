set default-list := true

# Configuration

theme := 'catppina'

light_variant := 'latte'
dark_variant := 'mocha'
theme_accent := 'blue'

theme_light := theme + '_light'
theme_dark := theme + '_dark'

root_dir := justfile_directory()
ports_dir := root_dir / 'ports'
dist_dir := root_dir / 'dist'
temp_dir := root_dir / '.temp'
scripts_dir := root_dir / 'scripts'

colors := read(root_dir / 'colors.json')
colors_no_hash := replace(colors, '#', '')

# Internal utilities

@_prepare_target target:
    rm -rf \
        {{ quote(temp_dir / target) }} \
        {{ quote(dist_dir / target) }}

    mkdir -p \
        {{ quote(temp_dir) }} \
        {{ quote(dist_dir / target) }}

    cp -R \
        {{ quote(ports_dir / target) }} \
        {{ quote(temp_dir / target) }}

@_build_deno target light_source dark_source extension: (_prepare_target target)
    echo -n 'Building {{ target }}...'

    cd {{ quote(temp_dir / target) }} && \
        deno task build \
            --color-overrides {{ quote(colors) }}

    mv \
        {{ quote(temp_dir / target / light_source) }} \
        {{ quote(dist_dir / target / (theme_light + '.' + extension)) }}

    mv \
        {{ quote(temp_dir / target / dark_source) }} \
        {{ quote(dist_dir / target / (theme_dark + '.' + extension)) }}

    echo ' done!'

@_build_whiskers target light_source dark_source extension: (_prepare_target target)
    echo -n 'Building {{ target }}...'

    cd {{ quote(temp_dir / target) }} && \
        whiskers \
            {{ quote(target + '.tera') }} \
            --color-overrides {{ quote(colors_no_hash) }}

    mv \
        {{ quote(temp_dir / target / light_source) }} \
        {{ quote(dist_dir / target / (theme_light + '.' + extension)) }}

    mv \
        {{ quote(temp_dir / target / dark_source) }} \
        {{ quote(dist_dir / target / (theme_dark + '.' + extension)) }}

    echo ' done!'

@_build_python target source extension: (_prepare_target target)
    echo -n 'Building {{ target }}...'

    cd {{ quote(temp_dir / target) }} && \
        whiskers \
            {{ quote(target + '.tera') }} \
            --color-overrides {{ quote(colors_no_hash) }}

    python3 \
        {{ quote(scripts_dir / (target + '.py')) }} \
        {{ quote(temp_dir / target / source) }} \
        {{ quote(light_variant) }} \
        {{ quote(theme_accent) }} \
        {{ quote(theme_light) }} \
        > {{ quote(dist_dir / target / (theme_light + '.' + extension)) }}

    python3 \
        {{ quote(scripts_dir / (target + '.py')) }} \
        {{ quote(temp_dir / target / source) }} \
        {{ quote(dark_variant) }} \
        {{ quote(theme_accent) }} \
        {{ quote(theme_dark) }} \
        > {{ quote(dist_dir / target / (theme_dark + '.' + extension)) }}

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

# Build targets

build_bat: (_build_deno \
    'bat' \
    'themes/Catppuccin Latte.tmTheme' \
    'themes/Catppuccin Mocha.tmTheme' \
    'tmTheme')

build_btop: (_build_whiskers \
    'btop' \
    'themes/catppuccin_latte.theme' \
    'themes/catppuccin_mocha.theme' \
    'theme')

build_delta: (_build_python \
    'delta' \
    'catppuccin.gitconfig' \
    'gitconfig')

build_fish: (_build_whiskers \
    'fish' \
    'themes/static/catppuccin-latte.theme' \
    'themes/static/catppuccin-mocha.theme' \
    'theme')

build_fzf: (_build_whiskers \
    'fzf' \
    'themes/catppuccin-fzf-latte.sh' \
    'themes/catppuccin-fzf-mocha.sh' \
    'sh')
    sed 's/set -Ux /set -gx /' \
        {{ quote(temp_dir / 'fzf/themes/catppuccin-fzf-latte.fish') }} \
        > {{ quote(dist_dir / 'fzf' / (theme_light + '.fish')) }}

    sed 's/set -Ux /set -gx /' \
        {{ quote(temp_dir / 'fzf/themes/catppuccin-fzf-mocha.fish') }} \
        > {{ quote(dist_dir / 'fzf' / (theme_dark + '.fish')) }}

build_ghostty: (_build_whiskers \
    'ghostty' \
    'themes/catppuccin-latte.conf' \
    'themes/catppuccin-mocha.conf' \
    'conf')

build_helix: (_build_whiskers \
    'helix' \
    'themes/default/catppuccin_latte.toml' \
    'themes/default/catppuccin_mocha.toml' \
    'toml')

build_lazygit: (_build_whiskers \
    'lazygit' \
    ('themes-mergable/' + light_variant + '/' + theme_accent + '.yml') \
    ('themes-mergable/' + dark_variant + '/' + theme_accent + '.yml') \
    'yml')

build_yazi: (_build_whiskers \
    'yazi' \
    ('themes/' + light_variant + '/catppuccin-' + light_variant + '-' + theme_accent + '.toml') \
    ('themes/' + dark_variant + '/catppuccin-' + dark_variant + '-' + theme_accent + '.toml') \
    'toml')

build_zed: (_build_python \
    'zed' \
    'themes/catppuccin-mauve.json' \
    'json')

build_zsh_syntax_highlighting: (_build_whiskers \
    'zsh-syntax-highlighting' \
    ('themes/catppuccin_' + light_variant + '-zsh-syntax-highlighting.zsh') \
    ('themes/catppuccin_' + dark_variant + '-zsh-syntax-highlighting.zsh') \
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
