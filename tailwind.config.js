module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      colors: {
        darkBackground: 'bg-zinc-700', // ここにカスタムカラーを追加
      },
    },
  },
  plugins: [require("daisyui")],
}
