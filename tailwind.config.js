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
        darkBackground: '#161616', // 適切な背景色を指定
        borderColor: 'rgba(229, 231, 235, 0.2)', // ボーダー色
        customGreen: '#78a22a'
      },
    },
  },
  plugins: [require("daisyui")],
}
