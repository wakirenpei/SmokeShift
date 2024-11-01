require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"

    config.time_zone = 'Tokyo'   # タイムゾーンを日本時間に設定
    config.active_record.default_timezone = :utc  # groupdateを使っているのでutcに設定

    # config.eager_load_paths << Rails.root.join("extras")
    config.generators do |g|
      g.helper false             # helper ファイルを作成しない
      g.test_framework :rspec,
        fixtures: false, # テストDBにレコードを作るfixtureの作成をスキップ(FactoryBotを使用するため)
        view_specs: false, # ビューファイル用のスペックを作成しない
        routing_specs: false # routes.rb用のスペックファイル作成しない
      g.skip_routes true         # ルーティングの記述を作成しない
    end
    config.autoload_paths += %W(#{config.root}/app/services)
    config.i18n.default_locale = :ja  # デフォルトのロケールを日本語(:ja)に設定
    config.i18n.load_path+=Dir[Rails.root.join('config','locales','**','*.yml').to_s]  # 訳文ファイルの読み込み先を追加
  end
end
