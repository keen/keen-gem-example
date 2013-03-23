function drawVisualizations() {
  new Keen.Metric("votes", {
    analysisType: "count"
  }).draw(document.getElementById("total-votes"), {
    label: "Total votes"
  })

  new Keen.Metric("votes", {
    analysisType: "count",
    groupBy: "character"
  }).draw(document.getElementById("voting-results"), {
    title: "Voting results",
    width: "400px"
  })
}

Keen.onChartsReady(drawVisualizations)

document.getElementById("refresh").
  addEventListener("click", function(event) {
    event.preventDefault()
    document.getElementById("total-votes").innerHTML = ""
    document.getElementById("voting-results").innerHTML = ""
    drawVisualizations()
  })
