class @ChangeTask
  constructor: (change_task_channel) ->
    @change_task_channel = change_task_channel
    ChangeTaskChannel.CALLBACK = change_task_callback

  init: ->
    $('.task-select').selectpicker();

  change_task_callback = (data) ->
    update_task_id_value(data)
    change_task_title(data)
    remove_confimation_vote()
    free_all_cards_from_users()

  update_task_id_value = (data) ->
    if inputs = $("[name='vote[task_id]']")
      inputs.each -> 
        @.value = data['task_id']

  change_task_title = (data) ->
    $('.page-header .title').html(data['title'])

  remove_confimation_vote = ->
    $('.card.selectable').removeClass('confirmed')

  free_all_cards_from_users = ->
    $('.finish-label').hide()
    $('.open-label').show()
    $('.page-header').data('room-status', 'in_progress')
    $('.card.selectable').not('.result').find('.inner').css('background', '#161ec9')
    $('.card.selectable').not('.result').css('border-color', '#161ec9')

  handler_events: ->
    handle_on_change_task_click.call(@)
    handle_on_revotation_task_cick.call(@)

  handle_on_change_task_click = ->
    ctc = @change_task_channel
    $('#start_votation').on 'click', ->
      selected = $('select.task-select').find('option:selected')
      $('#revotation').data('task_id', selected.val())
      remove_select_from_select_task()
      reset_votation()
      if task_id = selected.val()
        ctc.changeTask({ task_id: task_id })
      $('#start_votation_modal').modal('toggle')

  reset_votation = ->
    $('span.steps').each ->
      @.voted = undefined
      $('.steps').html('?')

  remove_select_from_select_task = ->
    $('.task-select').val('')
    $('.filter-option').html('Nothing Selected')
    $('.dropdown-menu .inner li').removeClass('selected')

  handle_on_revotation_task_cick = ->
    ctc = @change_task_channel
    $('#revotation').on 'click', ->
      ctc.changeTask({ task_id: $(@).data('task_id') })
      reset_votation()
      $('#finish_votation_modal').modal('toggle')
