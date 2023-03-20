import Chart from 'chart.js/auto'

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
            tension: 0.4
          },
          {
            label: '50th percentile',
            data: schoolScores.percentile_50.map(row => row.score),
            tension: 0.4,
          },
          {
            label: '25th percentile',
            data: schoolScores.percentile_25.map(row => row.score),
            tension: 0.4
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