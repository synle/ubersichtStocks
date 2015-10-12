# Separate stock symbols with a plus sign
symbols = "CRM+YHOO+PYPL+EBAY"

# See http://www.jarloo.com/yahoo_finance/ for Yahoo Finance options
command: "curl -s 'http://download.finance.yahoo.com/d/quotes.csv?s=#{symbols}&f=sl1c6p2' | sed 's/\"//g'"

refreshFrequency: 5000

style: """
  // Position this where you want
  top 450px
  left 25px

  // Change bar height
  bar-height = 6px

  // Align contents left or right
  widget-align = left

  

  // Statistics text settings
  color #fff
  font-family Helvetica Neue
  background rgba(#000, .5)
  padding 10px 10px 15px
  border-radius 5px

  .widget-title
    font-size 10px
    text-transform uppercase
    font-weight bold

  .container
    width: 300px
    text-align: widget-align
    clear: both
    font-size 10px

  .status-container
    overflow: hidden
    margin-bottom:5px
    box-sizing:border-box

  .status-container .label
    width:33.33%
    float:left

  .widget-title
    text-align: widget-align

  .bar-container
    margin-bottom:10px
    clear:both
    width:100%
    height: bar-height
    border-radius: bar-height
    background-color:grey

  .bar
    height:100%

  .bar-stock-status.low
    background: rgba(#c00, .5)

  .bar-stock-status.medium
    background: rgba(#fc0, .5)

  .bar-stock-status.high
    background: rgba(#0bf, .5)

  .incr
    color: rgba(#0f0, 0.7)

  .decr
    color: rgba(#f00, 0.7)

  .text-right
    text-align:right

  .text-center
    text-align:center
"""


render: -> """
  <div class="widget-title">Stock</div>
  <div id="stock-container">Loading</div>
"""

update: (output, domEl) ->
  domElJquery = $(domEl).find('#stock-container').empty();


  # label, val, change, changepct
  updateDom = (company, price, change, delta) ->
    company = company.trim()
    price = parseFloat(price.trim()).toFixed(2)
    change = change.trim()
    delta = delta.trim()

    if delta[0] is '+'
      deltaStatus = 'incr'
    else
      deltaStatus ='decr'

    domElJquery.append """
      <div class="container">
        <div class="status-container">
          <div class="label stock-company-label">#{company}</div>
          <div class="label text-center stock-price-label">#{price}</div>
          <div class="label text-right stock-delta-label #{deltaStatus}">#{change} (#{delta})</div>
        </div>
      </div>
    """

  stocks = output.split('\n')

  for stock, i in stocks
    args = stock.split(',')
    if (args[0])
      updateDom(args...)
