// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "chartkick/chart.js"
import Chart from 'chart.js/auto'
import ChartDataLabels from 'chartjs-plugin-datalabels'

Chart.register(ChartDataLabels)

Chart.defaults.set('plugins.datalabels', {
  color: 'white',
  backgroundColor: 'rgba(59, 130, 246, 0.7)',
  borderRadius: 4,
  font: {
    weight: 'bold'
  },
  formatter: (value, ctx) => {
    return value > 0 ? value : '';
  },
  display: (context) => context.dataset.data[context.dataIndex] > 0
})