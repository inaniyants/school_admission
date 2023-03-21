import Chart from 'chart.js/auto'
import colorLib from '@kurkle/color';

const CHART_COLORS = {
  red: 'rgb(255, 99, 132)',
  orange: 'rgb(255, 159, 64)',
  yellow: 'rgb(255, 205, 86)',
  green: 'rgb(75, 192, 192)',
  blue: 'rgb(54, 162, 235)',
  purple: 'rgb(153, 102, 255)',
  grey: 'rgb(201, 203, 207)'
}

function transparentize(value, opacity) {
  var alpha = opacity === undefined ? 0.5 : 1 - opacity;
  return colorLib(value).alpha(alpha).rgbString();
}

const SchoolScoresChart = {
  initChart() {
    const hook = this

    let chart

    const genData = (schoolScores) => {
      const years = schoolScores.percentile_50.map(row => row.year)

      return {
        labels: years,
        datasets: [
          {
            label: '75th percentile',
            data: schoolScores.percentile_75.map(row => row.score),
            tension: 0.4,
            borderColor: CHART_COLORS.blue,
            backgroundColor: transparentize(CHART_COLORS.blue),
          },
          {
            label: '50th percentile',
            data: schoolScores.percentile_50.map(row => row.score),
            tension: 0.4,
            borderColor: CHART_COLORS.purple,
            backgroundColor: transparentize(CHART_COLORS.purple),
          },
          {
            label: '25th percentile',
            data: schoolScores.percentile_25.map(row => row.score),
            tension: 0.4,
            borderColor: CHART_COLORS.orange,
            backgroundColor: transparentize(CHART_COLORS.orange),
          }
        ]
      }
    }

    hook.handleEvent('update_chart', (schoolScores) => {
      if (!chart) {
        chart = new Chart(
          hook.el.firstElementChild,
          {
            type: 'line',
            data: genData(schoolScores)
          }
        )

        return
      }

      chart.data = genData(schoolScores)
      chart.update()
    })
  },

  mounted() {
    this.initChart()
  },
}

export default SchoolScoresChart