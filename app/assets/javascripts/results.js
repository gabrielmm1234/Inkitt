function buildChart(response, name, container) {
  Highcharts.chart(container, {
      chart: {
          plotBackgroundColor: null,
          plotBorderWidth: null,
          plotShadow: false,
          type: 'pie'
      },
      title: {
          text: name
      },
      tooltip: {
          pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
      },
      plotOptions: {
          pie: {
              allowPointSelect: true,
              cursor: 'pointer',
              dataLabels: {
                  enabled: false
              },
              showInLegend: true
          }
      },
      series: [{
          name: 'Quantity',
          colorByPoint: true,
          data: response
      }]
  });
}

$(document).ready(function () {
  $.ajax({
      method: 'GET',
      url: '/quizzes/answers_distribution',
      dataType: 'json',
      success: function(response) {
        buildChart(response[0], 'Answer distribution for question 1: Do you want to be approved in Inkitt test?',
                   'question_1');
        buildChart(response[1], 'Answer distribution for question 2: What is your notice period?',
                  'question_2');
        buildChart(response[2], "Answer distribution for question 3: What's your favorite programming language?",
                  'question_3');
        buildChart(response[3], "Answer distribution for question 4: How many years of experience programming with your chosen language?",
                  'question_4');
        buildChart(response[4], "Answer distribution for question 5: Have you cried in Brazil x Germany game, in the last world cup?",
                  'question_5');
      }
    });
});
