class @FinishVotation
  constructor: (finish_votation_channel)->
    @finish_votation_channel = finish_votation_channel 
    FinishVotationChannel.CALLBACK = FinishVotation.finish_votation_callback

  @finish_votation_callback: ->
    block_all_cards_from_users()

  block_all_cards_from_users = ->
    $('.finish-label').show()
    $('.page-header').data('room-status', 'finish')
    $('.card.selectable').not('.confirmed').not('.result').find('.inner').css('background', 'gray')
    $('.card.selectable').not('.result').css('border-color', 'gray')

  handler_events: ->
    handle_on_finish_click.call(@)

  handle_on_finish_click = ->
    fv = @finish_votation_channel
    $('#finish_votation').on  'click', ->
      fv.finish()
      remove_all_card_result()
      calculate_result_from_votation()
      App.management_room.flip_cards()

  remove_all_card_result = ->
    $('.card-result').remove()

  calculate_result_from_votation = ->
    for num in [0..1]
      frequencies = {}
      $(".step-result-0#{num}").each ->
        unless @.voted == undefined
          frequencies[@.voted] = if frequencies[@.voted] == undefined 
            1
          else 
            frequencies[@.voted] + 1

      process_result_and_build_cards(frequencies, num)

  process_result_and_build_cards = (frequencies, step_number) ->
    max_value = Math.max.apply(null, Object.values(frequencies))

    result = []
    for key, value of frequencies
      if value >= max_value
        result.push key

    html = ''

    for card in result
      html += """
        <div class="card-result col-lg-4 col-md-3 col-xs-6">
          <div class="card-container">
            <div class="card selectable result">
              <div class="inner">
                <a href='javascript:void(0)' class='card-label'>#{card}</a>
              </div>
            </div>
          </div>
        </div>
      """

    $(".step-0#{step_number}").html(html)

$(document).on 'turbolinks:load', ->
  fv = new FinishVotation(FinishVotationChannel.get_instance())
  fv.handler_events()
