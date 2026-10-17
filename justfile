set default-list

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

colors := replace(read(root_dir / 'colors.json'), '#', '')

# Internal utilities

@_generate target:
    echo 'Building {{ target }}...'

    rm -rf \
        {{ quote(temp_dir / target) }} \
        {{ quote(dist_dir / target) }}

    mkdir -p \
        {{ quote(temp_dir) }} \
        {{ quote(dist_dir / target) }}

    cp -R \
        {{ quote(ports_dir / target) }} \
        {{ quote(temp_dir / target) }}

    cd {{ quote(temp_dir / target) }} && \
        whiskers {{ quote(target + '.tera') }} --color-overrides {{ quote(colors) }}

@_build_whiskers target light_source dark_source extension: (_generate target)
    mv \
        {{ quote(temp_dir / target / light_source) }} \
        {{ quote(dist_dir / target / (theme_light + '.' + extension)) }}

    mv \
        {{ quote(temp_dir / target / dark_source) }} \
        {{ quote(dist_dir / target / (theme_dark + '.' + extension)) }}

@_build_node target source extension: (_generate target)
    node \
        {{ quote(scripts_dir / (target + '.js')) }} \
        {{ quote(temp_dir / target / source) }} \
        {{ quote(light_variant) }} \
        {{ quote(theme_light) }} \
        > {{ quote(dist_dir / target / (theme_light + '.' + extension)) }}

    node \
        {{ quote(scripts_dir / (target + '.js')) }} \
        {{ quote(temp_dir / target / source) }} \
        {{ quote(dark_variant) }} \
        {{ quote(theme_dark) }} \
        > {{ quote(dist_dir / target / (theme_dark + '.' + extension)) }}

# Lifecycle

@prepare:
    echo 'Preparing...'

    pnpm install --frozen-lockfile

    rm -rf \
        {{ quote(temp_dir) }} \
        {{ quote(dist_dir) }}

    mkdir -p \
        {{ quote(temp_dir) }} \
        {{ quote(dist_dir) }}

@clean:
    rm -rf {{ quote(temp_dir) }}

# Build targets

build_btop: (_build_whiskers \
    'btop' \
    ('themes/catppuccin_' + light_variant + '.theme') \
    ('themes/catppuccin_' + dark_variant + '.theme') \
    'theme')

build_delta: (_build_node \
    'delta' \
    'catppuccin.gitconfig' \
    'gitconfig')

build_fish: (_build_whiskers \
    'fish' \
    ('themes/static/catppuccin-' + light_variant + '.theme') \
    ('themes/static/catppuccin-' + dark_variant + '.theme') \
    'theme')

build_fzf: (_build_whiskers \
    'fzf' \
    ('themes/catppuccin-fzf-' + light_variant + '.sh') \
    ('themes/catppuccin-fzf-' + dark_variant + '.sh') \
    'sh')
    sed 's/set -Ux /set -gx /' \
        {{ quote(temp_dir / ('fzf/themes/catppuccin-fzf-' + light_variant + '.fish')) }} \
        > {{ quote(dist_dir / 'fzf' / (theme_light + '.fish')) }}

    sed 's/set -Ux /set -gx /' \
        {{ quote(temp_dir / ('fzf/themes/catppuccin-fzf-' + dark_variant + '.fish')) }} \
        > {{ quote(dist_dir / 'fzf' / (theme_dark + '.fish')) }}

build_ghostty: (_build_whiskers \
    'ghostty' \
    ('themes/catppuccin-' + light_variant + '.conf') \
    ('themes/catppuccin-' + dark_variant + '.conf') \
    'conf')

build_gitui: (_build_whiskers \
    'gitui' \
    ('themes/catppuccin-' + light_variant + '.ron') \
    ('themes/catppuccin-' + dark_variant + '.ron') \
    'ron')

build_helix: (_build_whiskers \
    'helix' \
    ('themes/default/catppuccin_' + light_variant + '.toml') \
    ('themes/default/catppuccin_' + dark_variant + '.toml') \
    'toml')

build_lazygit: (_build_whiskers \
    'lazygit' \
    ('themes-mergable/' + light_variant + '/' + theme_accent + '.yml') \
    ('themes-mergable/' + dark_variant + '/' + theme_accent + '.yml') \
    'yml')

build_posting: (_generate 'posting')
    sed 's/^name: .*/name: "{{ theme_light }}"/' \
        {{ quote(temp_dir / 'posting' / ('themes/' + light_variant + '/catppuccin-' + light_variant + '-' + theme_accent + '.yaml')) }} \
        > {{ quote(dist_dir / 'posting' / (theme_light + '.yaml')) }}

    sed 's/^name: .*/name: "{{ theme_dark }}"/' \
        {{ quote(temp_dir / 'posting' / ('themes/' + dark_variant + '/catppuccin-' + dark_variant + '-' + theme_accent + '.yaml')) }} \
        > {{ quote(dist_dir / 'posting' / (theme_dark + '.yaml')) }}

build_vscode:
    node {{ quote(scripts_dir / 'vscode.js') }}

build_yazi: (_build_whiskers \
    'yazi' \
    ('themes/' + light_variant + '/catppuccin-' + light_variant + '-' + theme_accent + '.toml') \
    ('themes/' + dark_variant + '/catppuccin-' + dark_variant + '-' + theme_accent + '.toml') \
    'toml')

build_zed: (_build_node \
    'zed' \
    'themes/catppuccin-mauve.json' \
    'json')

build_zellij: (_generate 'zellij')
    node \
        {{ quote(scripts_dir / 'zellij.js') }} \
        {{ quote(temp_dir / 'zellij/catppuccin.kdl') }} \
        > {{ quote(dist_dir / 'zellij' / (theme + '.kdl')) }}

build_zsh_syntax_highlighting: (_build_whiskers \
    'zsh-syntax-highlighting' \
    ('themes/catppuccin_' + light_variant + '-zsh-syntax-highlighting.zsh') \
    ('themes/catppuccin_' + dark_variant + '-zsh-syntax-highlighting.zsh') \
    'zsh')

# Aggregate build

@_build_all: \
    build_btop \
    build_delta \
    build_fish \
    build_fzf \
    build_ghostty \
    build_gitui \
    build_helix \
    build_lazygit \
    build_posting \
    build_vscode \
    build_yazi \
    build_zed \
    build_zellij \
    build_zsh_syntax_highlighting \
    && clean

build: prepare && _build_all
