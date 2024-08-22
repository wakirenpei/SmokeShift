module.exports = {
  mode: 'jit', // ピクセル値を使えるようにする
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      colors: {
        darkBackground: '#161616', // 主な背景色
        borderColor: 'rgba(229, 231, 235, 0.2)', // ボーダー色
        borderColor2: 'rgba(229, 231, 235, 0.1)', // ボーダー色
        customGreen: '#78a22a', // カスタムグリーン
        customForm: '#232323', // フォームのテキスト欄の背景色
        labelColor: '#D4D4D4', // ラベルの文字色
      },
    },
  },
  plugins: [require("daisyui")],
}
