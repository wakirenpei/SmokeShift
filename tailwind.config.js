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
        customGreenHover: '#5c7a20', // カスタムグリーンのhover時の色
        customForm: '#232323', // フォームのテキスト欄の背景色
        labelColor: '#D4D4D4', // ラベルの文字色
        secondaryButton: '#4A5568', // セカンダリボタンの背景色
        secondaryButtonHover: '#2D3748',
        cardBackground: '#2a2a2a', // カードの背景色
        itemBackground: '#333333', // アイテムの背景色
      },
    },
  },
  plugins: [require("daisyui")],
}
